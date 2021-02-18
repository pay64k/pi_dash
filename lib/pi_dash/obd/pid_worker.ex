defmodule Obd.PidWorker do
  use GenServer

  require Logger

  # Show current data
  @obd_mode "01"

  def start_link(obd_pid, interval \\ 1000) do
    name = String.to_atom(obd_pid)
    {int_obd_pid, _} = Integer.parse(obd_pid, 16)
    GenServer.start(__MODULE__, [int_obd_pid, obd_pid, interval], name: name)
  end

  def init(opts = [int_obd_pid, obd_pid, interval]) do
    Logger.info("Starting #{inspect __MODULE__} with opts: #{inspect opts}")
    {:ok, %{int_obd_pid: int_obd_pid, obd_pid: obd_pid, interval: interval, tref: nil}}
  end

  def handle_info(:start, state = %{interval: interval}) do
    {:ok, tref} = :timer.send_interval(interval, self(), :write)
    {:ok, %{state | tref: tref}}
  end

  def handle_info(:write, state = %{obd_pid: obd_pid}) do
    ElmConnector.send(@obd_mode <> obd_pid)
    {:noreply, state}
  end

  def handle_info(%{data: data, pid: int_obd_pid}, state = %{int_obd_pid: int_obd_pid}) do
    {translated, units} = Obd.DataTranslator.handle_data(int_obd_pid, data)

    msg = %{value: translated, obd_pid: int_obd_pid, units: units}

    Logger.debug(
      "obd pid worker #{int_obd_pid} recieved data: #{inspect(data, binaries: :as_binaries)}, translated: #{
        translated
      } #{units}"
    )

    PiDashWeb.RoomChannel.send_to_channel(msg)
    {:noreply, state}
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
