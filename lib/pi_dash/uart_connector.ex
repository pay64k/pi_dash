defmodule UartConnector do
  use GenServer

  require Logger

  def start_link(serial_port) do
    GenServer.start_link(__MODULE__, [serial_port], name: __MODULE__)
  end

  def init([serial_port]) do
    uart_port_pid = Process.whereis(Circuits.UART)

    res =
      case open_serial(uart_port_pid, serial_port) do
        :ok ->
          elm_opts = [
            "Z", # reset all
            "D", # set all to default
            "E0", # echo off
            "SO0", # set protocol to automatic
            "CFC1", # flowcontrol
            "AL", # allow long messages
            "H1", # show headers
            "L0", # no line feeds
            "S0", # no whitespaces
          ]
          Logger.info("Setting up ELM with commands: #{inspect elm_opts}")
          Enum.each(elm_opts, fn command -> send({:at, command}) end)
          :ok
      end

    {res, %{serial_port: serial_port, uart_port_pid: uart_port_pid}}
  end

  def send({:at, data}) do
    GenServer.cast(__MODULE__, {:send, "AT" <> data})
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_cast({:send, data}, state = %{uart_port_pid: pid}) do
    :ok = Circuits.UART.write(pid, data)
    {:noreply, state}
  end

  def handle_info({:circuits_uart, serial_port, data}, state = %{serial_port: serial_port}) do
    Logger.debug("received on #{serial_port}: #{inspect(data)}")
    handle_data(data)
    {:noreply, state}
    # cond do
    #   String.contains?(data, "ELM") ->
    #     Logger.info("ATZ succeeded! Happy pi_dashing!")
    #     {:noreply, state}

    #   String.contains?(data, "A") -> {:noreply, state}
    #   String.contains?(data, "\r") -> {:noreply, state}
    #   String.contains?(data, "L") -> {:noreply, state}
    #   String.contains?(data, "T") -> {:noreply, state}
    #   String.contains?(data, "Z") -> {:noreply, state}
    #   String.contains?(data, "E") -> {:noreply, state}
    #   String.contains?(data, "M") -> {:noreply, state}
    #   String.contains?(data, "3") -> {:noreply, state}
    #   String.contains?(data, "2") -> {:noreply, state}
    #   String.contains?(data, "7") -> {:noreply, state}
    #   String.contains?(data, " ") -> {:noreply, state}
    #   String.contains?(data, "v") -> {:noreply, state}
    #   String.contains?(data, "1") -> {:noreply, state}
    #   String.contains?(data, ".") -> {:noreply, state}
    #   String.contains?(data, "5") -> {:noreply, state}

    #   true ->
    #     data
    #     |> prepare_received
    #     |> to_binary
    #     |> format_data
    #     |> propagate_data

    #     {:noreply, state}
    # end
  end

  def handle_data(data) do
    :ok
  end

  defp prepare_received(data) do
    data
    |> String.replace(" \r", "")
    |> String.replace("\r", "")
    |> String.replace(">", "")
    |> String.replace(" ", "")
  end

  defp to_binary(data) do
    supl_data =
      case rem(byte_size(data), 2) do
        0 -> data
        1 -> "0" <> data
      end

    Base.decode16!(supl_data)
  end

  defp format_data(<<_id1, _id2, _size, mode, pid, data::binary>>) do
    %{mode: mode, pid: pid, data: data}
  end

  defp propagate_data(data) do
    Enum.each(Obd.PidSup.children(), fn {_id, worker_pid, _, _} -> send(worker_pid, data) end)
  end

  defp open_serial(uart_port_pid, serial_port) do
    Logger.info("Attemting to connect to ELM on serial port: #{inspect(serial_port)} ...")

    opts = [
      speed: 3800,
      data_bits: 8,
      parity: :none,
      stop_bits: 1,
      framing: {Circuits.UART.Framing.Line, separator: "\r"}
    ]

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
