defmodule ElmTest do
  use ExUnit.Case

  setup_all do
    ExMeck.new(Circuits.UART, [:passthrough])
    ExMeck.expect(Circuits.UART, :open, fn _, _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :write, fn _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :enumerate, fn -> [{"port", %{manufacturer: "Prolific"}}] end)

    pid = start_connector()

    on_exit(fn ->
      ExMeck.unload()
    end)

    {:ok, connector_pid: pid, serial_port: "port"}
  end

  test "sunny day - full configuration ok", context do
    full_configuration(context)
  end

  # Private

  defp full_configuration(context) do
    assert_wrote("AT Z")
    assert get_state() == :configuring
    send_to_connector("ELM v1.5", context)
    assert get_state() == :configuring
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
    assert get_state() == :get_supported_pids
    assert_wrote("0100")
    send_to_connector("BE1FA813", context)
    assert_wrote("0900")
    send_to_connector("A9236C71", context)
    assert get_state() == :connected_configured
  end

  defp send_to_connector(msg, context) do
    pid = context[:connector_pid]
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
    assert true == ExMeck.contains?(Circuits.UART, {:_, {Circuits.UART, :write, [:_, msg]}, :_})
  end

  defp get_state() do
    {state, _state_data} =
      Elm.Connector
      |> Process.whereis()
      |> :sys.get_state()

    state
  end
end
