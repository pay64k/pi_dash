defmodule Elm.Data do
  defstruct [
    :port,
    :uart_port_pid,
    :elm_queue,
    :elm_version,
    :last_sent_command,
    :protocol_number,
    supported_pids: []
  ]
end

defmodule Elm.Connector do
  use GenStateMachine
  alias Elm.Data
  alias Obd.PidTranslator, as: PT
  require Logger

  @elm_device_name "Prolific"

  @obd_pids_supported [
    "01" <> PT.name_to_pid(:pids_a)
    # TODO: renable after coorect pids calculations are done (pid + offset)
    # "01" <> PT.name_to_pid(:pids_b),
    # "01" <> PT.name_to_pid(:pids_c)
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
    {:ok, uart_port_pid} = Circuits.UART.start_link()
    GenStateMachine.cast(__MODULE__, :open_connection)
    {:ok, :connect, %Data{elm_queue: elm_opts(), uart_port_pid: uart_port_pid}}
  end

  def handle_event(
        :info,
        {:circuits_uart, port, {:error, :einval}},
        state,
        data = %Data{port: port}
      ) do
    Logger.error("ELM disconnected on #{port} in state: #{state}")
    GenStateMachine.cast(__MODULE__, :open_connection)
    {:next_state, :connect, %Data{data | elm_queue: elm_opts()}}
  end

  def handle_event(:info, {:circuits_uart, port, ""}, _state, _data = %Data{port: port}) do
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

  def handle_event(:cast, :open_connection, :connect, data) do
    case open_serial(data.uart_port_pid) do
      {:ok, port} ->
        case System.get_env("TEST_MODE", nil) do
          "true" ->
            start_pid_sup()
            {:next_state, :connected_configured, %{data | port: port}}

          nil ->
            write_at_command("Z")
            {:next_state, :configuring, %{data | port: port, last_sent_command: "Z"}}
        end

      :error ->
        Process.sleep(5000)
        GenStateMachine.cast(__MODULE__, :open_connection)
        :keep_state_and_data
    end
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

        {:next_state, :get_supported_pids,
         %Data{data | protocol_number: msg, last_sent_command: to_send, elm_queue: rest}}

      true ->
        :keep_state_and_data
    end
  end

  defp handle_msg(msg, :get_supported_pids, data) do
    cond do
      String.contains?(msg, "SEARCHING") ->
        :keep_state_and_data

      String.contains?(msg, "UNABLE TO CONNECT") ->
        Logger.error("Unable to connect to vehicle ECU! Restarting...")
        GenStateMachine.cast(__MODULE__, :open_connection)
        {:next_state, :connect, %Data{data | elm_queue: elm_opts()}}

      data.last_sent_command in @obd_pids_supported ->
        next = {!String.contains?(msg, "NO DATA"), Enum.count(data.elm_queue) > 0}
        Logger.debug(":get_supported_pids {next}: #{inspect(next)}")

        case next do
          {false, true} ->
            Logger.warn("NO DATA for supported pids #{data.last_sent_command}")
            {to_send, rest} = List.pop_at(data.elm_queue, 0)
            write_command(to_send)

            {:next_state, :get_supported_pids,
             %Data{data | last_sent_command: to_send, elm_queue: rest}}

          {false, false} ->
            Logger.warn("NO DATA for supported pids #{data.last_sent_command}")
            start_pid_sup()
            {:next_state, :connected_configured, data}

          {true, true} ->
            supported = Obd.DataTranslator.parse_supported_pids(msg)
            Logger.info("Supported PIDs: #{inspect(supported)}")
            {to_send, rest} = List.pop_at(data.elm_queue, 0)
            write_command(to_send)

            {:next_state, :get_supported_pids,
             %Data{
               data
               | supported_pids: data.supported_pids ++ supported,
                 last_sent_command: to_send,
                 elm_queue: rest
             }}

          {true, false} ->
            supported = Obd.DataTranslator.parse_supported_pids(msg)
            Logger.info("Supported PIDs: #{inspect(supported)}")
            start_pid_sup()

            {
              :next_state,
              :connected_configured,
              # TODO store supported pids with mode e.g 01 01
              %Data{data | supported_pids: data.supported_pids ++ [supported]}
            }
        end
    end
  end

  defp handle_msg("NO DATA", :connected_configured, _data) do
    Logger.error("Lost conenction to car's ECU! Restarting...")
    GenStateMachine.cast(__MODULE__, :open_connection)
    {:next_state, :connect, %Data{}}
  end

  # TODO handle: Got from ELM: ">NO DATA", state: :connected_configured

  defp handle_msg(msg, :connected_configured, _data) do
    case check_data(msg) do
      :discarding ->
        Logger.warn(
          "Discarding incomplete data: #{msg}, due to odd size of bytes (#{byte_size(msg)}"
        )

        :keep_state_and_data

      _ ->
        to_send = %{obd_pid_name: obd_pid_name} = Obd.DataTranslator.decode_data(msg)
        send(Process.whereis(obd_pid_name), {:process, to_send})
        :keep_state_and_data
    end
  end

  defp prepare_received(msg) do
    if System.get_env("TEST_MODE") do
      new_msg =
        msg
        |> String.replace(">", "")
        |> String.replace(" ", "")

      "1" <> new_msg <> "11"
    else
      msg = String.replace(msg, ">", "")

      case rem(byte_size(msg), 2) do
        0 -> msg
        _ -> "0" <> msg
      end
    end
  end

  defp check_data(hex_string) do
    case rem(byte_size(hex_string), 2) do
      0 -> hex_string
      _ -> :discarding
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

    serial_port = serial_port()

    Logger.info(
      "Attemting to connect to ELM on serial port: #{inspect(serial_port)} with opts: #{
        inspect(opts)
      }"
    )

    res = Circuits.UART.open(uart_port_pid, serial_port, opts)

    case res do
      :ok ->
        Logger.info("Connected to ELM on serial port #{inspect(serial_port)}!")
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

  def serial_port() do
    case find_serial_port() do
      {nil, all_serial_devices} ->
        Logger.error(
          "Serial device from manfucturer #{@elm_device_name}, not found!
           Attemting to use device set in config. All available serial devices: #{
            inspect(all_serial_devices)
          }"
        )

        Application.get_env(:pi_dash, :serial_port, :not_set)

      {name, _info} ->
        name
    end
  end

  defp find_serial_port() do
    devices = Circuits.UART.enumerate()

    found =
      Enum.filter(devices, fn {_, m} ->
        :manufacturer in Map.keys(m) and
          String.contains?(m.manufacturer, @elm_device_name)
      end)

    cond do
      List.first(found) == nil -> {nil, devices}
      true -> List.first(found)
    end
  end

  def start_pid_sup() do
    child = [
      %{
        id: Obd.PidSup,
        start: {Obd.PidSup, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, max_restarts: 0]
    {:ok, pid} = Supervisor.start_link(child, opts)
    pid
  end
end
