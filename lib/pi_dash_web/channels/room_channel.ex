defmodule PiDashWeb.RoomChannel do
  use PiDashWeb, :channel
  require Logger

  def send_to_channel(msg_type, data) do
    Phoenix.PubSub.broadcast(
      PiDash.PubSub,
      "room:dash",
      {msg_type, data}
    )
  end

  def join(channel_name, _params, socket) do
    {:ok, %{channel: channel_name}, socket}
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_in("status:supported_pids", _params, socket) do
    pids =
      Elm.Connector.get_supported_pids()
      |> from_pid_to_name()
      |> filter_pids()
      |> construct_supported_pids_msg()

    push(socket, "status:supported_pids", %{supported_pids: pids})
    {:noreply, socket}
  end

  def handle_in("status:start_pid_worker", %{"pid_name" => pid_name, "interval" => interval}, socket) do
    Obd.PidSup.start_pid_worker(pid_name, interval)
    {:noreply, socket}
  end

  def handle_in("status:elm_status", _params, socket) do
    elm_status = Elm.Connector.get_state()
    push(socket, "status:elm_status", %{elm_status: elm_status})
    {:noreply, socket}
  end

  def handle_info({msg_type = :update, %{obd_pid_name: name, value: value}}, socket) do
    topic = Atom.to_string(msg_type) <> ":" <> Atom.to_string(name)
    push(socket, topic, %{value: value})
    {:noreply, socket}
  end

  defp from_pid_to_name(list) do
    for pid <- list, do: Obd.PidTranslator.pid_to_name(pid)
  end

  defp filter_pids(supported_pids) do
    app_supported_pids_names =
      Application.fetch_env!(:pi_dash, :app_supported_pids)
      |> Enum.map(fn %{obd_pid_name: p} -> p end)

    MapSet.intersection(
      MapSet.new(supported_pids),
      MapSet.new(app_supported_pids_names)
    )
    |> MapSet.to_list()
  end

  defp construct_supported_pids_msg(supported_pids) do
    app_supported_pids_names = Application.fetch_env!(:pi_dash, :app_supported_pids)

    Enum.filter(app_supported_pids_names, fn %{obd_pid_name: name} ->
      name in supported_pids
    end)
  end
end
