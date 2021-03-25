defmodule ElmConnectorTest do
  use ExUnit.Case

  setup do
    ExMeck.new(PiDashWeb.RoomChannel, [:passthrough])
    ExMeck.expect(PiDashWeb.RoomChannel, :send_to_channel, fn _, _ -> :ok end)

    ExMeck.new(Circuits.UART, [:passthrough])
    ExMeck.expect(Circuits.UART, :open, fn _, _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :write, fn _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :enumerate, fn -> %{"port" => %{manufacturer: "Prolific"}} end)

    elm_pid = start_connector()

    {:ok, _pid} =
      start_supervised(%{
        id: Elm.PidSup,
        start: {Elm.PidSup, :start_link, []}
      })

    {:ok, _pid} =
      start_supervised(%{
        id: Car,
        start: {Car, :start_link, [elm_pid]}
      })

    # Car.start_link(elm_pid)

    on_exit(fn ->
      ExMeck.unload()
    end)

    {:ok, elm_pid: elm_pid, serial_port: "port"}
  end

  test "sunny day - full configuration ok", context do
    assert full_configuration(context)
  end

  test "restart on no response from ELM in connect state", _context do
    assert_state(:configuring)
    assert_wrote("AT Z")
    timeout()
    assert_wrote("AT Z")
    assert_state(:configuring)
  end

  test "connect and dont restart after no response (no pids configured)", context do
    assert full_configuration(context)
    timeout()
    refute_wrote("AT Z")
    assert_state(:connected_configured)
  end

  # TODO
  test "connect and get NO DATA, then restart", context do
    assert full_configuration(context)
    timeout()
    send_to_connector(">NO DATA", context)
    # assert_wrote("AT Z")
    Process.sleep(100)
  end

  test "start and recieve some data - sunny day", context do
    assert full_configuration(context)

    Elm.PidSup.start_pid_worker(:rpm)
    assert_state(:connected_configured)

    refute_wrote("AT Z")
    Car.start_sending(:rpm, 100)
    refute_wrote("AT Z")
    Process.sleep(200)

    assert ExMeck.contains?(
             PiDashWeb.RoomChannel,
             {:_, {PiDashWeb.RoomChannel, :send_to_channel, [:update, :_]}, :_}
           )
  end

  # TODO
  test "start and receive data then get NO DATA and resume connection", context do
    assert full_configuration(context)

    Elm.PidSup.start_pid_worker(:rpm)
    assert_state(:connected_configured)

    refute_wrote("AT Z")

    Car.start_sending(:rpm, 300)
    Process.sleep(2000)
    Car.stop_sending(:rpm)

    send_to_connector(">NO DATA", context)
    # assert full_configuration(context)
  end

  # Private

  defp timeout() do
    delay = Application.fetch_env!(:pi_dash, :connect_timeout) + 100
    Process.sleep(delay)
  end

  defp full_configuration(context) do
    assert_wrote("AT Z")
    assert_state(:configuring)
    send_to_connector("ELM v1.5", context)
    assert_state(:configuring)
    send_to_connector("OK", context)
    assert_wrote("AT E0")
    send_to_connector("OK", context)
    assert_wrote("AT CFC1")
    send_to_connector("OK", context)
    assert_wrote("AT AL")
    send_to_connector("OK", context)
    assert_wrote("AT H1")
    send_to_connector("OK", context)
    assert_wrote("AT L0")
    send_to_connector("OK", context)
    assert_wrote("AT S0")
    send_to_connector("OK", context)
    assert_wrote("AT DPN")
    send_to_connector("A0", context)
    assert_state(:get_supported_pids)
    assert_wrote("0100")
    send_to_connector("486B104100BE1FA813C9", context)
    assert_wrote("0120")
    send_to_connector("486B104120BE1FAFF3C9", context)
    assert_wrote("0140")
    send_to_connector("486B104140BE1FAA13C9", context)
    assert_state(:connected_configured)
    true
  end

  defp send_to_connector(msg, context) do
    pid = context[:elm_pid]
    port = context[:serial_port]
    send(pid, {:circuits_uart, port, msg})
  end

  defp start_connector() do
    {:ok, pid} =
      start_supervised(%{
        id: Elm.Connector,
        start: {Elm.Connector, :start_link, []}
      })

    pid
  end

  defp assert_wrote(msg) do
    assert ExMeck.contains?(Circuits.UART, {:_, {Circuits.UART, :write, [:_, msg]}, :_})
    ExMeck.reset(Circuits.UART)
  end

  defp refute_wrote(msg) do
    refute ExMeck.contains?(Circuits.UART, {:_, {Circuits.UART, :write, [:_, msg]}, :_})
    ExMeck.reset(Circuits.UART)
  end

  defp assert_state(state) do
    assert state == get_state()
  end

  defp get_state() do
    {state, _state_data} =
      Elm.Connector
      |> Process.whereis()
      |> :sys.get_state()

    state
  end
end
