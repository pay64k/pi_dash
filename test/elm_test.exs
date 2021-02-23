defmodule ElmTest do
  use ExUnit.Case

  setup_all do
    ExMeck.new(Circuits.UART, [:passthrough])
    ExMeck.expect(Circuits.UART, :open, fn _, _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :write, fn _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :enumerate, fn -> [] end)

    serial_port = "test_port"

    pid = start_connector(serial_port)

    on_exit(fn ->
      ExMeck.unload()
    end)
    {:ok, connector_pid: pid, serial_port: serial_port}
  end

  test "open connection", context do
    assert get_state() == :configuring
    send_to_connector("ELM v1.5", context)
    assert get_state() == :configuring
    
  end

  defp send_to_connector(msg, context) do
    pid = context[:connector_pid]
    port = context[:serial_port]
    send(pid, {:circuits_uart, port, msg})
  end

  defp start_connector(serial_port) do
    {:ok, pid} =
      start_supervised(%{
        id: Elm.ConnectorStatem,
        start: {Elm.ConnectorStatem, :start_link, [serial_port]}
      })
      pid
  end

  defp get_state() do
    {state, _state_data} =
      Elm.ConnectorStatem
      |> Process.whereis()
      |> :sys.get_state()
    state
  end
end
