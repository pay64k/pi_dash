defmodule ElmConnector do
  use GenServer

  require Logger

  def start_link(serial_port) do
    GenServer.start_link(__MODULE__, [serial_port], name: __MODULE__)
  end

  def init([serial_port]) do
    {:ok, uart_port_pid} = Circuits.UART.start_link()

    res =
      case open_serial(uart_port_pid, serial_port) do
        :ok ->
          elm_opts = [
            "Z", # reset all
            "E0", # echo off
            "SP0", # set protocol to automatic
            "CFC1", # flowcontrol
            "AL", # allow long messages
            "H1", # show headers
            "L0", # no line feeds
            "S0", # no whitespaces
            "DPN", # Describe the Protocol by Number
            "0100" # PIDs supported [01 - 20]
          ]

          Logger.info("Setting up ELM with commands: #{inspect(elm_opts)}")
          Enum.each(elm_opts, fn command -> send({:at, command}) end)
          :ok
      end

    :timer.send_after(5000, self() , :start_workers)
    {res, %{serial_port: serial_port, uart_port_pid: uart_port_pid}}
  end

  def send({:at, data = "0100"}) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def send({:at, data}) do
    GenServer.cast(__MODULE__, {:send, "AT" <> data})
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_cast({:send, data}, state = %{uart_port_pid: pid}) do
    Logger.info("Sending #{inspect(data)}")
    :ok = Circuits.UART.write(pid, data)
    {:noreply, state}
  end

  def handle_info(:start_workers, state) do
    send_to_workers(:start)
    {:noreply, state}
  end

  def handle_info({:circuits_uart, serial_port, ""}, state = %{serial_port: serial_port}) do
    {:noreply, state}
  end
  def handle_info({:circuits_uart, serial_port, data}, state = %{serial_port: serial_port}) do
    Logger.debug("received on #{serial_port}: clean: #{inspect prepare_received(data)} , raw: #{inspect(data)}")

    clean_data = prepare_received(data)
    # data
    # |> prepare_received
    # |> handle_data

    # {:noreply, state}
    cond do
      String.starts_with?(clean_data, "AT") or
      String.contains?(clean_data, "OK") or
      String.contains?(clean_data, "ELM") or
      String.contains?(clean_data, "TDPN") or
      String.contains?(clean_data, "SEARCHING...") or
      String.equivalent?(clean_data, "A") or
      String.equivalent?(clean_data, "A0") or
      String.equivalent?(clean_data, "0100") or
      String.contains?(clean_data, "486B104100BE3EB811C9") ->
        {:noreply, state}

      true ->
        clean_data
        # |> prepare_received
        |> to_binary
        |> format_data
        |> send_to_workers

        {:noreply, state}
    end
  end

  # def handle_data(">OK"), do: :ok
  # def handle_data("A0"), do: :ok
  # def handle_data("SEARCHING..."), do: :ok
  # def handle_data("ELM327 v1.5"), do: :ok
  # def handle_data(_), do: :ok

  # def handle_data(data) do
  #   data
  #   |> prepare_received
  #   |> to_binary
  #   |> format_data
  #   |> send_to_workers
  # end

  defp prepare_received(data) do
    data
    |> String.replace(">", "")
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

  defp format_data(<<_id1, _id2, mode, pid, data::binary>>) do
    %{mode: mode, pid: pid, data: data}
  end

  # TODO: send only to the one with matching pid
  defp send_to_workers(data) do
    Enum.each(Obd.PidSup.children(), fn {_id, worker_pid, _, _} -> send(worker_pid, data) end)
  end

  defp open_serial(uart_port_pid, serial_port) do
    Logger.info("Attemting to connect to ELM on serial port: #{inspect(serial_port)} ...")

    opts = [
      speed: 38400,
      data_bits: 8,
      parity: :none,
      stop_bits: 1,
      framing: {Circuits.UART.Framing.Line, separator: "\r"},
      # rx_framing_timeout: 1,
      active: true
      # id: :pid
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