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
          Logger.info("Sedning ATZ...")
          UartConnector.send("ATZ")
      end

    {res, %{serial_port: serial_port, uart_port_pid: uart_port_pid}}
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_cast({:send, data}, state = %{uart_port_pid: pid}) do
    :ok = Circuits.UART.write(pid, data <> "\n\r")
    {:noreply, state}
  end

  def handle_info({:circuits_uart, serial_port, data}, state = %{serial_port: serial_port}) do
    Logger.debug("received on #{serial_port}: #{inspect(data)}")

    cond do
      String.contains?(data, "ELM") ->
        Logger.info("ATZ succeeded! Happy pi_dashing!")
        {:noreply, state}

      true ->
        data
        |> prepare_received
        |> to_binary
        |> format_data
        |> handle_data

        {:noreply, state}
    end
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

  defp handle_data(data) do
    Enum.each(Obd.PidSup.children(), fn {_id, worker_pid, _, _} -> send(worker_pid, data) end)
  end

  defp open_serial(uart_port_pid, serial_port) do
    Logger.info("Attemting to connect to ELM on serial port: #{inspect(serial_port)} ...")
    res = Circuits.UART.open(uart_port_pid, serial_port, speed: 38400)

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
