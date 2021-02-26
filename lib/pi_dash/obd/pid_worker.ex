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
    Logger.info("Starting #{inspect(__MODULE__)} with opts: #{inspect(opts)}")
    {:ok, tref} = :timer.send_interval(interval, self(), :write)
    {:ok,
     %{int_obd_pid: int_obd_pid, obd_pid: obd_pid, interval: interval, tref: tref, last_value: 0}}
  end

  def handle_info(:write, state = %{obd_pid: obd_pid}) do
    Elm.Connector.write_command(@obd_mode <> obd_pid)
    {:noreply, state}
  end

  def handle_info(
        msg = %{data: data, pid: int_obd_pid},
        state = %{int_obd_pid: int_obd_pid, last_value: last_value}
      ) do
    Logger.debug(
      "obd pid worker #{int_obd_pid} recieved data: #{inspect(data, binaries: :as_binaries)}"
    )

    case Obd.DataTranslator.handle_data(msg) do
      {:error, reason} ->
        Logger.warn(
          "could not translate: #{inspect(data, binaries: :as_binaries)}, reason: #{
            inspect(reason)
          }"
        )

        to_web = %{value: last_value, obd_pid: int_obd_pid, units: nil}
        PiDashWeb.RoomChannel.send_to_channel(to_web)
        {:noreply, state}

      {value, units} ->
        Logger.debug("obd pid worker #{int_obd_pid} translated data: #{inspect(value)} #{units}")
        to_web = %{value: value, obd_pid: int_obd_pid, units: units}
        PiDashWeb.RoomChannel.send_to_channel(to_web)
        {:noreply, %{state | last_value: value}}
    end
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
