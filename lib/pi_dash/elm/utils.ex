defmodule Elm.Utils do

  require Logger

  @elm_device_name "Prolific"
  @elm_serial_names ["OBDII"]

  def serial_port() do
    case find_serial_port() do
      {nil, all_serial_devices} ->
        Logger.error(
          "Serial device from manfucturer #{@elm_device_name}, not found!
           Attemting to use device set in config. All available serial devices: #{
            inspect(all_serial_devices)
          }"
        )

        Application.get_env(:pi_dash, :serial_port, :not_set)

      {name, _info} ->
        name
    end
  end

  defp find_serial_port() do
    devices = Circuits.UART.enumerate()

    found =
      Enum.filter(devices, fn {port, m} ->
        (:manufacturer in Map.keys(m) and
          String.contains?(m.manufacturer, @elm_device_name))
          or
        Enum.filter(@elm_serial_names, fn d ->
          String.contains?(d, port)
        end)
      end)

    cond do
      List.first(found) == nil -> {nil, devices}
      true -> List.first(found)
    end
  end

end
