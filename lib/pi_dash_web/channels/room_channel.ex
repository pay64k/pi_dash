defmodule PiDashWeb.RoomChannel do
  use PiDashWeb, :channel

  def send_to_channel(data) do
    Phoenix.PubSub.broadcast(
      PiDash.PubSub,
      "room:dash",
      data
    )
  end

  def join(channel_name, _params, socket) do
    {:ok, %{channel: channel_name}, socket}
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end

  def handle_info(data, socket) do
    push(socket, "update", data)
    {:noreply, socket}
  end
end
