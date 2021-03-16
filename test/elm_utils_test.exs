defmodule ElmUtilsTest do
  use ExUnit.Case

  alias Elm.Utils

  setup do
    ExMeck.new(Circuits.UART, [:passthrough])
    ExMeck.expect(Circuits.UART, :open, fn _, _, _ -> :ok end)
    ExMeck.expect(Circuits.UART, :write, fn _, _ -> :ok end)

    on_exit(fn ->
      ExMeck.unload()
    end)
  end

  test "Two devices connected - choose the USB one" do
    ExMeck.expect(Circuits.UART, :enumerate, fn ->
      %{"serial_port" => %{manufacturer: "Prolific"}, "/dev/cu.OBDII-SPPslave" => %{}}
    end)

    assert "serial_port" == Utils.serial_port()
  end

  test "One device connected - supported manufacturer" do
    supported_manuf = Application.get_env(:pi_dash, :supported_manufacturers)

    Enum.each(supported_manuf, fn manuf ->
      ExMeck.expect(Circuits.UART, :enumerate, fn ->
        %{"serial_port" => %{manufacturer: manuf}}
      end)

      assert "serial_port" == Utils.serial_port()
    end)
  end

  test "One device connected - supported port name" do
    supported_port_names = Application.get_env(:pi_dash, :supported_serial_names)

    Enum.each(supported_port_names, fn port ->
      ExMeck.expect(Circuits.UART, :enumerate, fn ->
        %{port => %{}}
      end)

      assert port == Utils.serial_port()
    end)
  end

  test "No supported device connected - use one in config" do
    ExMeck.expect(Circuits.UART, :enumerate, fn -> %{} end)
    assert Application.get_env(:pi_dash, :serial_port) == Utils.serial_port()
  end

  test "No supported devices, but other non supported present - use one from config" do
    ExMeck.expect(Circuits.UART, :enumerate, fn ->
      %{
        "/dev/cu.Bluetooth-Incoming-Port" => %{},
        "/dev/cu.LGSH2DD-BTSPP1" => %{},
        "/dev/cu.LGSH2DD-BTSPP2" => %{},
        "/dev/cu.LGSH2DD-BTSPP3" => %{}
      }
    end)

    assert Application.get_env(:pi_dash, :serial_port) == Utils.serial_port()
  end
end
