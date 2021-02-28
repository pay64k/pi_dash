defmodule Obd.PidWorker do
  use GenServer

  require Logger

  # Show current data
  @obd_mode "01"

  def start_link(obd_pid_name, interval \\ 1000) do
    GenServer.start(__MODULE__, [obd_pid_name, interval], name: obd_pid_name)
  end

  def init(opts = [obd_pid_name, interval]) do
    Logger.info("Starting #{inspect(__MODULE__)} with opts: #{inspect(opts)}")
    {:ok, tref} = :timer.send_interval(interval, self(), :write)
    obd_pid_hex_string = Obd.PidTranslator.name_to_pid(obd_pid_name)
    {:ok,
     %{obd_pid_name: obd_pid_name, obd_pid_hex_string: obd_pid_hex_string, interval: interval, tref: tref, last_value: 0}}
  end

  def handle_info(:write, state = %{obd_pid_hex_string: obd_pid_hex_string}) do
    Elm.Connector.write_command(@obd_mode <> obd_pid_hex_string)
    {:noreply, state}
  end

  def handle_info(
        {:process, msg},
        state = %{obd_pid_name: obd_pid_name, last_value: last_value}
      ) do
    Logger.debug(
      "Pid worker #{inspect obd_pid_name} recieved data: #{inspect(msg.data, binaries: :as_binaries)}"
    )

    case Obd.DataTranslator.handle_data(msg) do
      {:error, reason} ->
        Logger.warn(
          "could not translate: #{inspect(msg.data, binaries: :as_binaries)}, reason: #{
            inspect(reason)
          }"
        )

        to_web = %{value: last_value, obd_pid: obd_pid_name, units: nil}
        PiDashWeb.RoomChannel.send_to_channel(:update, to_web)
        {:noreply, state}

      {value, units} ->
        Logger.debug("obd pid worker #{obd_pid_name} translated data: #{inspect(value)} #{units}")
        to_web = %{value: value, obd_pid: obd_pid_name, units: units}
        PiDashWeb.RoomChannel.send_to_channel(:update, to_web)
        {:noreply, %{state | last_value: value}}
    end
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
