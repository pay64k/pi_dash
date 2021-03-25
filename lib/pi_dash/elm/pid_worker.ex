defmodule Elm.PidWorker do
  use GenServer

  require Logger

  # Show current data
  @obd_mode "01"

  def start_link(obd_pid_name, extra_logging, write_interval \\ 1000) do
    GenServer.start(__MODULE__, [obd_pid_name, write_interval, extra_logging], name: obd_pid_name)
  end

  def init(opts = [obd_pid_name, write_interval, extra_logging]) do
    Logger.info("Starting #{inspect(__MODULE__)} with opts: #{inspect(opts)}")
    obd_pid_hex_string = Obd.PidTranslator.name_to_pid(obd_pid_name)

    nudge_interval = Application.fetch_env!(:pi_dash, :nudge_interval)
    nudge_tref = Process.send_after(self(), :write_nudge, nudge_interval)

    write_tref = Process.send_after(self(), :write, write_interval)

    {:ok,
     %{
       obd_pid_name: obd_pid_name,
       obd_pid_hex_string: obd_pid_hex_string,
       last_value: 0,
       write_interval: write_interval,
       write_tref: write_tref,
       nudge_interval: nudge_interval,
       nudge_tref: nudge_tref,
       nudge_writes: 0,
       extra_logging: extra_logging
     }}
  end

  def handle_info(:write, state = %{obd_pid_hex_string: obd_pid_hex_string}) do
    Elm.Connector.write_command(@obd_mode <> obd_pid_hex_string)
    nudge_tref = Elm.Utils.renew_timer(state.nudge_tref, :write_nudge, state.nudge_interval)
    {:noreply, %{state | nudge_tref: nudge_tref}}
  end

  def handle_info(
        :write_nudge,
        state = %{
          obd_pid_hex_string: obd_pid_hex_string,
          obd_pid_name: obd_pid_name,
          nudge_writes: n,
          nudge_tref: nudge_tref,
          nudge_interval: nudge_interval
        }
      ) do
    Logger.warn("Nudge write in #{obd_pid_name}, happened: #{n + 1} times.")
    Elm.Connector.write_command(@obd_mode <> obd_pid_hex_string)
    nudge_tref = Elm.Utils.renew_timer(nudge_tref, :write_nudge, nudge_interval)
    {:noreply, %{state | nudge_writes: n + 1, nudge_tref: nudge_tref}}
  end

  def handle_info(
        {:process, msg},
        state = %{
          last_value: last_value,
          write_interval: write_interval,
          extra_logging: extra_logging,
          obd_pid_name: obd_pid_name
        }
      ) do
    if extra_logging,
      do:
        Logger.debug(
          "Pid worker #{inspect(obd_pid_name)} recieved data: #{
            inspect(msg.data, binaries: :as_binaries)
          }"
        )

    case Obd.DataTranslator.handle_data(msg) do
      {:error, reason} ->
        Logger.warn("#{inspect(obd_pid_name)} could not translate: #{inspect(msg.data)}, binary:
          #{inspect(msg.data, binaries: :as_binaries)}, reason: #{inspect(reason)}")

        to_web = format_msg_to_web(last_value, state)
        PiDashWeb.RoomChannel.send_to_channel(:update, to_web)
        write_tref = Elm.Utils.renew_timer(state.write_tref, :write, write_interval)
        {:noreply, %{state | write_tref: write_tref}}

      value ->
        if extra_logging,
          do: Logger.debug("obd pid worker #{obd_pid_name} translated data: #{inspect(value)}")

        to_web = format_msg_to_web(value, state)
        PiDashWeb.RoomChannel.send_to_channel(:update, to_web)
        write_tref = Elm.Utils.renew_timer(state.write_tref, :write, write_interval)
        {:noreply, %{state | last_value: value, write_tref: write_tref}}
    end
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end

  defp format_msg_to_web(value, state),
    do: %{value: round(value), obd_pid_name: state.obd_pid_name}
end
