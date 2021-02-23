defmodule Elm.Data do
  defstruct [
    :port,
    :uart_port_pid,
    :elm_opts,
    :elm_version,
    :last_sent_at_command
  ]
end

defmodule Elm.ConnectorStatem do
  use GenStateMachine
  alias Elm.Data
  require Logger

  @elm_opts [
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
    "DPN",
    # PIDs supported [01 - 20]
    "0100"
  ]

  def write_at_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, "AT " <> msg})
  end

  def write_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, msg})
  end

  def start_link() do
    GenStateMachine.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, uart_port_pid} = Circuits.UART.start_link()
    GenStateMachine.cast(__MODULE__, :open_connection)
    {:ok, :connect, %Data{elm_opts: @elm_opts, uart_port_pid: uart_port_pid}}
  end

  def handle_event(
        :info,
        {:circuits_uart, port, {:error, :einval}},
        state,
        data = %Data{port: port}
      ) do
    Logger.error("ELM disconnected on #{port} in state: #{state}")
    GenStateMachine.cast(__MODULE__, :open_connection)
    {:next_state, :connect, %Data{data | elm_opts: @elm_opts}}
  end

  def handle_event(:info, {:circuits_uart, port, ""}, _state, _data = %Data{port: port}) do
    :keep_state_and_data
  end

  def handle_event(:info, {:circuits_uart, port, msg}, state, data = %Data{port: port}) do
    Logger.debug("Got from ELM: \t#{inspect(msg)}, state: #{inspect(state)}")

    msg
    |> prepare_received()
    |> handle_msg(state, data)
  end

  def handle_event(:cast, {:write, msg}, state, data) do
    Logger.debug("Write to ELM: \t#{inspect(msg)}, state: #{inspect(state)}")
    :ok = Circuits.UART.write(data.uart_port_pid, msg)
    :keep_state_and_data
  end

  def handle_event(:cast, :open_connection, :connect, data) do
    case open_serial(data.uart_port_pid) do
      {:ok, port} ->
        write_at_command("Z")
        {:next_state, :configuring, %{data | port: port, last_sent_at_command: "Z"}}

      :error ->
        Process.sleep(5000)
        GenStateMachine.cast(__MODULE__, :open_connection)
        :keep_state_and_data
    end
  end

  defp handle_msg(msg, :configuring, data) do
    cond do
      String.contains?(msg, "Z") and data.last_sent_at_command == "Z" ->
        :keep_state_and_data

      String.contains?(msg, "ELM") and data.last_sent_at_command == "Z" ->
        Logger.info("Connected ELM version: #{msg}")
        {to_send, rest} = List.pop_at(data.elm_opts, 0)
        write_at_command(to_send)

        {:next_state, :configuring,
         %Data{data | elm_version: msg, last_sent_at_command: to_send, elm_opts: rest}}

      String.contains?(msg, "OK") ->
        {to_send, rest} = List.pop_at(data.elm_opts, 0)
        write_at_command(to_send)
        {:next_state, :configuring, %Data{data | last_sent_at_command: to_send, elm_opts: rest}}

        #TODO: handle going to connected_configured (get available pids, then start PidSup etc)

      true ->
        :keep_state_and_data
    end
  end

  defp prepare_received(msg) do
    msg
    |> String.replace(">", "")
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

        :error
    end
  end

  def serial_port() do
    case find_serial_port() do
      nil -> Application.get_env(:pi_dash, :serial_port, :not_set)
      {name, _info} -> name
    end
  end

  defp find_serial_port() do
    Circuits.UART.enumerate()
    |> Enum.filter(fn {_, m} ->
      :manufacturer in Map.keys(m) and
        String.contains?(m.manufacturer, "Prolific")
    end)
    |> List.first()
  end
end
