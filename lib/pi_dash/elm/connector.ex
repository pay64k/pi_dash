defmodule Elm.Data do
  defstruct [
    :port,
    :uart_port_pid,
    :elm_queue,
    :elm_version,
    :last_sent_command,
    :protocol_number,
    supported_pids: [],
    tref: nil,
    extra_logging: false
  ]
end

defmodule Elm.Connector do
  use GenStateMachine
  alias Elm.{Data, Utils}
  alias Obd.PidTranslator, as: PT
  require Logger

  @obd_pids_supported [
    "01" <> PT.name_to_pid(:pids_a),
    "01" <> PT.name_to_pid(:pids_b),
    "01" <> PT.name_to_pid(:pids_c)
  ]

  def write_at_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, "AT " <> msg})
  end

  def write_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, msg})
  end

  def get_supported_pids() do
    GenStateMachine.call(__MODULE__, :get_supported_pids)
  end

  def get_state() do
    GenStateMachine.call(__MODULE__, :get_state)
  end

  def start_link() do
    GenStateMachine.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Logger.debug("Starting #{__MODULE__} (init)")
    {:ok, uart_port_pid} = Circuits.UART.start_link()
    extra_logging = Application.fetch_env!(:pi_dash, :extra_logging)
    GenStateMachine.cast(__MODULE__, :open_connection)

    {:ok, :connect,
     %Data{elm_queue: elm_opts(), uart_port_pid: uart_port_pid, extra_logging: extra_logging}}
  end

  def handle_event(
        :info,
        {:circuits_uart, port, {:error, :einval}},
        state,
        data = %Data{port: port}
      ) do
    Logger.error("ELM disconnected on #{port} in state: #{state}")
    connect!(data)
  end

  def handle_event(:info, {:circuits_uart, port, ""}, _state, _data = %Data{port: port}) do
    :keep_state_and_data
  end

  def handle_event(
        :info,
        {:circuits_uart, port, ">NO DATA"},
        :connected_configured,
        _data = %Data{port: port}
      ) do
    # Logger.error(
    #   "Lost conenction to car's ECU! (Got 'NO DATA' from ELM in :connected_configured state) Starting connect timer..."
    # )
    Logger.warn("Got NO DATA, moving on.")
    Obd.PidSup.nudge_workers()
    # tref = renew_timer(:connect_timeout)
    # Obd.PidSup.stop_all_workers()
    # {:next_state, :connected_configured, %Data{data | tref: tref}}
    :keep_state_and_data
  end

  def handle_event(:info, {:circuits_uart, port, msg}, state, data = %Data{port: port}) do
    Logger.debug("Got from ELM: #{inspect(msg)}, state: #{inspect(state)}")

    msg
    |> prepare_received()
    |> handle_msg(state, data)
  end

  def handle_event(:cast, {:write, msg}, state, data) do
    Logger.debug("Write to ELM: #{inspect(msg)}, state: #{inspect(state)}")

    :ok = Circuits.UART.write(data.uart_port_pid, msg)
    :keep_state_and_data
  end

  def handle_event(:info, :connect_timeout, state, data) do
    Logger.warn(
      "Didn't get a response from ELM (state: #{state}, last sent: #{data.last_sent_command}). Restarting..."
    )

    connect!(data)
  end

  def handle_event({:call, from}, :get_supported_pids, state, data) do
    res =
      if System.get_env("TEST_MODE") do
        for %{hex: h} <- Application.fetch_env!(:pi_dash, :app_supported_pids), do: h
      else
        data.supported_pids |> List.flatten() |> Enum.uniq()
      end

    {:next_state, state, data, [{:reply, from, res}]}
  end

  def handle_event({:call, from}, :get_state, state, data) do
    {:next_state, state, data, [{:reply, from, state}]}
  end

  def handle_event(:cast, :open_connection, :connect, data = %{uart_port_pid: uart_port_pid}) do
    case open_serial(uart_port_pid) do
      {:ok, port} ->
        case System.get_env("TEST_MODE", nil) do
          "true" ->
            {:next_state, :connected_configured, %Data{data | port: port}}

          nil ->
            write_at_command("Z")
            tref = renew_timer(:connect_timeout)

            {:next_state, :configuring,
             %Data{data | port: port, last_sent_command: "Z", tref: tref}}
        end

      :error ->
        Process.sleep(5000)
        GenStateMachine.cast(__MODULE__, :open_connection)
        {:next_state, :connect, %Data{data | tref: nil}}
    end
  end

  def handle_event(:cast, :open_connection, _state, _data) do
    :keep_state_and_data
  end

  defp handle_msg(msg, :configuring, data) do
    cond do
      String.contains?(msg, "Z") and data.last_sent_command == "Z" ->
        :keep_state_and_data

      String.contains?(msg, "ELM") and data.last_sent_command == "Z" ->
        Logger.info("Connected ELM version: #{msg}")
        {to_send, rest} = List.pop_at(data.elm_queue, 0)
        write_at_command(to_send)

        {:next_state, :configuring,
         %Data{data | elm_version: msg, last_sent_command: to_send, elm_queue: rest}}

      String.contains?(msg, "OK") ->
        {to_send, rest} = List.pop_at(data.elm_queue, 0)
        write_at_command(to_send)
        {:next_state, :configuring, %Data{data | last_sent_command: to_send, elm_queue: rest}}

      String.contains?(msg, "A") and data.last_sent_command == "DPN" ->
        {to_send, rest} = List.pop_at(@obd_pids_supported, 0)
        write_command(to_send)

        tref = renew_timer(data.tref, :connect_timeout)

        {:next_state, :get_supported_pids,
         %Data{
           data
           | protocol_number: msg,
             last_sent_command: to_send,
             elm_queue: rest,
             tref: tref
         }}

      true ->
        :keep_state_and_data
    end
  end

  defp handle_msg(msg, :get_supported_pids, data) do
    cond do
      String.contains?(msg, "SEARCHING") ->
        tref = renew_timer(data.tref, :connect_timeout)
        {:next_state, :get_supported_pids, %Data{data | tref: tref}}

      String.contains?(msg, "UNABLE TO CONNECT") ->
        Logger.error("Unable to connect to vehicle ECU! Restarting...")
        connect!(data)

      data.last_sent_command in @obd_pids_supported ->
        next = {!String.contains?(msg, "NO DATA"), Enum.count(data.elm_queue) > 0}
        Logger.debug(":get_supported_pids {next}: #{inspect(next)}")

        case next do
          {false, true} ->
            tref = renew_timer(data.tref, :connect_timeout)

            Logger.warn("NO DATA for supported pids #{data.last_sent_command}")
            {to_send, rest} = List.pop_at(data.elm_queue, 0)
            write_command(to_send)

            {:next_state, :get_supported_pids,
             %Data{data | last_sent_command: to_send, elm_queue: rest, tref: tref}}

          {false, false} ->
            Process.cancel_timer(data.tref)

            Logger.warn("NO DATA for supported pids #{data.last_sent_command}")
            {:next_state, :connected_configured, data}

          {true, true} ->
            tref = renew_timer(data.tref, :connect_timeout)

            supported = Obd.DataTranslator.parse_supported_pids(msg)
            pretty_log_supported_pids(supported)
            {to_send, rest} = List.pop_at(data.elm_queue, 0)
            write_command(to_send)

            {:next_state, :get_supported_pids,
             %Data{
               data
               | supported_pids: data.supported_pids ++ supported,
                 last_sent_command: to_send,
                 elm_queue: rest,
                 tref: tref
             }}

          {true, false} ->
            Process.cancel_timer(data.tref)
            supported = Obd.DataTranslator.parse_supported_pids(msg)
            pretty_log_supported_pids(supported)

            {
              :next_state,
              :connected_configured,
              %Data{data | supported_pids: data.supported_pids ++ [supported]}
            }
        end
    end
  end

  defp handle_msg(msg, :connected_configured, _data) do
    translated =
      case Obd.DataTranslator.decode_data(msg) do
        :error -> nil
        t -> t
      end

    case translated do
      nil ->
        :keep_state_and_data

      %{obd_pid_name: obd_pid_name} ->
        pid = Process.whereis(obd_pid_name)
        if pid != nil do
          send(pid, {:process, translated})
          :keep_state_and_data
        else
          :keep_state_and_data
        end
    end
  end

  defp connect!(data) do
    GenStateMachine.cast(__MODULE__, :open_connection)
    tref = renew_timer(data.tref, :connect_timeout)

    {:next_state, :connect,
     %Data{uart_port_pid: data.uart_port_pid, elm_queue: elm_opts(), tref: tref}}
  end

  defp renew_timer(msg = :connect_timeout) do
    Process.send_after(self(), msg, connect_timeout())
  end

  defp renew_timer(old_ref, msg = :connect_timeout) do
    renew_timer(old_ref, msg, connect_timeout())
  end

  defp renew_timer(old_ref, msg, timeout) do
    Process.cancel_timer(old_ref)
    Process.send_after(self(), msg, timeout)
  end

  defp prepare_received(msg) do
    if System.get_env("TEST_MODE") do
      msg =
        msg
        |> String.replace(">", "")
        |> String.replace(" ", "")

      "1" <> msg <> "11"
    else
      msg = String.replace(msg, ">", "")

      case rem(byte_size(msg), 2) do
        0 -> msg
        _ -> "0" <> msg
      end
    end
  end

  defp elm_opts() do
    case System.get_env("TEST_MODE", nil) do
      "true" ->
        []

      nil ->
        [
          # echo off
          "E0",
          # set protocol to automatic
          "SP0",
          # flowcontrol
          "CFC1",
          # allow long messages
          "AL",
          # show headers
          "H1",
          # no line feeds
          "L0",
          # no whitespaces
          "S0",
          # Describe the Protocol by Number
          "DPN"
        ]
    end
  end

  defp open_serial(uart_port_pid) do
    # TODO: pass opts from application, from env
    opts = [
      speed: 38400,
      data_bits: 8,
      parity: :none,
      stop_bits: 1,
      framing: {Circuits.UART.Framing.Line, separator: "\r"},
      active: true
    ]

    serial_port = Utils.serial_port()

    Logger.info(
      "Attemting to connect to ELM on serial port: #{inspect(serial_port)} with opts: #{
        inspect(opts)
      }"
    )

    res = Circuits.UART.open(uart_port_pid, serial_port, opts)

    case res do
      :ok ->
        Logger.info("Serial port #{inspect(serial_port)} opened...")
        {:ok, serial_port}

      {:error, reason} ->
        Logger.error(
          "Connection to ELM failed, device on #{inspect(serial_port)} serial port not found! Reason: #{
            inspect(reason)
          }"
        )

        # TODO handle :eagain
        :error
    end
  end

  defp connect_timeout() do
    Application.fetch_env!(:pi_dash, :connect_timeout)
  end

  defp pretty_log_supported_pids(pids) do
    pretty = for p <- pids, do: Obd.PidTranslator.pid_to_name(p)

    Logger.info("Supported PIDs hex: #{inspect(pids)}")
    Logger.info("Supported PIDs names: #{inspect(pretty, limit: :infinity, pretty: true)}")
  end
end
