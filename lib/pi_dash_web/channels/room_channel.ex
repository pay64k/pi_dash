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

  def handle_in("supported_pids", _params, socket) do
    pids = [:speed, :rpm]
    push(socket, "supported_pids", %{supported_pids: pids})
    {:noreply, socket}
  end

  def handle_in("status:elm_state", _params, socket) do
    Logger.info("recevied mesg on elm_state")
    elm_state = Elm.Connector.get_state()
    push(socket, "status:elm_state", %{elm_state: elm_state})
    {:noreply, socket}
  end

  def handle_info({msg_type = :update, %{obd_pid_name: name, value: value}}, socket) do
    topic = Atom.to_string(msg_type) <> ":" <> Atom.to_string(name)
    push(socket, topic, %{value: value})
    {:noreply, socket}
  end
end
