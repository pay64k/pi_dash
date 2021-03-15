defmodule ElmUtilsTest do
  use ExUnit.Case

  alias Elm.Utils

  setup do
    ExMeck.new(Circuits.UART, [:passthrough])
    ExMeck.expect(Circuits.UART, :open, fn _, _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :write, fn _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :enumerate, fn -> [{"port", %{manufacturer: "Prolific"}}] end)

    on_exit(fn ->
      ExMeck.unload()
    end)
  end

  test "find_supported_devices", _context do
    ExMeck.expect(Circuits.UART, :enumerate, fn -> %{"port" => %{manufacturer: "Prolific"}, "/dev/cu.OBDII-SPPslave" => %{}} end)
    Utils.serial_port() |> IO.inspect()
  end

  end
