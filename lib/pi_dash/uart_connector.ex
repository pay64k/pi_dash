defmodule UartConnector do
  use GenServer

  def start_link(serial_port) do
    GenServer.start_link(__MODULE__, [serial_port], name: __MODULE__)
  end

  def init([serial_port]) do
    uart_port_pid = Process.whereis(Circuits.UART)

    :ok = Circuits.UART.open(uart_port_pid, serial_port, speed: 38400)

    {:ok, %{serial_port: serial_port, uart_port_pid: uart_port_pid}}
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_cast({:send, data}, state = %{uart_port_pid: pid}) do
    :ok = Circuits.UART.write(pid, data <> "\n\r")
    {:noreply, state}
  end

  def handle_info({:circuits_uart, serial_port, data}, state = %{serial_port: serial_port}) do
    data
    |> prepare_received
    |> to_binary
    |> format_data
    |> handle_data

    {:noreply, state}
  end

  defp prepare_received(data) do
    data
    |> String.replace(" \r", "")
    |> String.replace("\r", "")
    |> String.replace(">", "")
    |> String.replace(" ", "")
    # |> IO.inspect()
  end

  defp to_binary(data) do
    supl_data =
      case rem(byte_size(data), 2) do
        0 -> data
        1 -> "0" <> data
      end

    Base.decode16!(supl_data)
    # |> IO.inspect()
  end

  defp format_data(<<_id1, _id2, _size, mode, pid, data::binary>>) do
    %{mode: mode, pid: pid, data: data}
  end

  defp handle_data(data) do
    Enum.each(Obd.PidSup.children(), fn {_id, worker_pid, _, _} -> send(worker_pid, data) end)
  end
end
