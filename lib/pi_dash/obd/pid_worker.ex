defmodule Obd.PidWorker do
  use GenServer

  @obd_mode "01" # Show current data

  def start_link(obd_pid) do
    name = String.to_atom(obd_pid)
    {int_obd_pid, _} = Integer.parse(obd_pid, 16)
    GenServer.start(__MODULE__, [int_obd_pid, obd_pid], name: name)
  end

  def init([int_obd_pid, obd_pid]) do
    tref = Process.send_after(self(), :write, 1000)
    # :timer.send_interval(@poll_interval, self(), :check_cluster)
    {:ok, %{int_obd_pid: int_obd_pid, obd_pid: obd_pid, tref: tref}}
  end

  def handle_info(:write, state = %{obd_pid: obd_pid, tref: tref}) do
    Process.cancel_timer(tref)
    UartConnector.send(@obd_mode <> obd_pid)
    tref = Process.send_after(self(), :write, 1000)
    {:noreply, %{state | tref: tref}}
  end

  def handle_info(%{data: data, pid: int_obd_pid}, state = %{int_obd_pid: int_obd_pid}) do
    {translated, units} = Obd.DataTranslator.handle_data(int_obd_pid, data)

    msg = %{value: translated, obd_pid: int_obd_pid, units: units}
    PiDashWeb.RoomChannel.send_to_channel(msg)
    IO.puts("obd worker #{int_obd_pid} recieved data: #{inspect(data)}, translated: #{translated} #{units}")
    {:noreply, state}
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
