defmodule PidWorkerkTest do
  use ExUnit.Case

  setup do
    ExMeck.new(PiDashWeb.RoomChannel, [:passthrough])
    ExMeck.expect(PiDashWeb.RoomChannel, :send_to_channel, fn _, _ -> :ok end)

    on_exit(fn ->
      ExMeck.unload()
    end)

  end

  test "start and write and send some data" do
    p = start(:rpm)
    send(p, {:process, %{data: <<59, 46, 17>>, obd_pid_name: :rpm}})
    Process.sleep(1000)
  end

  defp start(obd_pid_name, interval \\ 100) do
    {:ok, pid} =
      start_supervised(%{
        id: obd_pid_name,
        start: {Elm.PidWorker, :start_link, [obd_pid_name, true, interval]}
      })
      pid
  end

end
