defmodule Obd.PidWorker do
  use GenServer

  require Logger

  @obd_mode "01" # Show current data

  def start_link(obd_pid) do
    name = String.to_atom(obd_pid)
    {int_obd_pid, _} = Integer.parse(obd_pid, 16)
    GenServer.start(__MODULE__, [int_obd_pid, obd_pid], name: name)
  end

  def init([int_obd_pid, obd_pid]) do
    :timer.send_interval(1000, self(), :write)
    {:ok, %{int_obd_pid: int_obd_pid, obd_pid: obd_pid}}
  end

  def handle_info(:write, state = %{obd_pid: obd_pid}) do
    UartConnector.send(@obd_mode <> obd_pid)
    {:noreply, state}
  end

  def handle_info(%{data: data, pid: int_obd_pid}, state = %{int_obd_pid: int_obd_pid}) do
    {translated, units} = Obd.DataTranslator.handle_data(int_obd_pid, data)

    msg = %{value: translated, obd_pid: int_obd_pid, units: units}
    Logger.debug("obd pid worker #{int_obd_pid} recieved data: #{inspect(data, binaries: :as_binaries)}, translated: #{translated} #{units}")
    PiDashWeb.RoomChannel.send_to_channel(msg)
    {:noreply, state}
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
