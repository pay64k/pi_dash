defmodule Elm.Data do
  defstruct [
    :port,
    :uart_port_pid,
    :elm_opts,
    :elm_version
  ]
end

defmodule Elm.ConnectorStatem do
  use GenStateMachine
  alias Elm.Data
  require Logger

  def write_at_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, "AT " <> msg})
  end

  def write_command(msg) do
    GenStateMachine.cast(__MODULE__, {:write, msg})
  end

  def start_link(port) do
    GenStateMachine.start_link(__MODULE__, [port], name: __MODULE__)
  end

  def init([port]) do
    {:ok, uart_port_pid} = Circuits.UART.start_link()

    elm_opts = [
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

    GenStateMachine.cast(__MODULE__, :open_connection)
    {:ok, :connect, %Data{elm_opts: elm_opts, port: port, uart_port_pid: uart_port_pid}}
  end

  def handle_event(:info, {:circuits_uart, port, ""}, _state, _data = %Data{port: port}) do
    :keep_state_and_data
  end

  def handle_event(:info, {:circuits_uart, port, msg}, state, data = %Data{port: port}) do
    Logger.debug("Received from ELM: #{inspect(msg)}, state: #{inspect state}")
    handle_msg(msg, state, data)
  end

  def handle_event(:cast, {:write, msg}, state, data) do
    Logger.debug("Write to ELM: #{inspect(msg)}, state: #{inspect state}")
    :ok = Circuits.UART.write(data.uart_port_pid, msg)
    :keep_state_and_data
  end

  def handle_event(:cast, :open_connection, :connect, data) do
    case open_serial(data.uart_port_pid, data.port) do
      :ok ->
        write_at_command("Z")
        {:next_state, :configuring , data}

      :error ->
        Process.sleep(5000)
        GenStateMachine.cast(__MODULE__, :open_connection)
        :keep_state_and_data
    end
  end

  defp handle_msg(msg, :configuring, data) do
    cond do
      String.contains?(msg, "Z") ->
        :keep_state_and_data

      String.contains?(msg, "ELM") ->
        Logger.info("Connected ELM version: #{msg}")
        {:next_state, :configuring, %Data{data | elm_version: msg}}

      true ->
        :keep_state_and_date
    end
  end

  defp open_serial(uart_port_pid, serial_port) do
    # TODO: pass opts from application, from env
    opts = [
      speed: 38400,
      data_bits: 8,
      parity: :none,
      stop_bits: 1,
      framing: {Circuits.UART.Framing.Line, separator: "\r"},
      active: true
    ]

    Logger.info(
      "Attemting to connect to ELM on serial port: #{inspect(serial_port)} with opts: #{
        inspect(opts)
      }"
    )

    res = Circuits.UART.open(uart_port_pid, serial_port, opts)

    case res do
      :ok ->
        Logger.info("Connected to ELM on serial port #{inspect(serial_port)}!")
        :ok

      {:error, reason} ->
        Logger.error(
          "Connection to ELM failed, device on #{inspect(serial_port)} serial port not found! Reason: #{
            inspect(reason)
          }"
        )

        :error
    end
  end
end
