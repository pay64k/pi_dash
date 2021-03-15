defmodule Elm.Utils do
  require Logger

  def serial_port() do
    case find_serial_port() do
      {nil, all_serial_devices} ->
        Logger.warn(
          "Serial device from manfucturers list: #{
            Application.get_env(:pi_dash, :supported_manufacturers)
          }, not found!
           Attemting to use device set in config. All available serial devices: #{
            inspect(all_serial_devices)
          }"
        )

        Application.get_env(:pi_dash, :serial_port)

      {name, _info} ->
        name
    end
  end

  defp find_serial_port() do
    devices = Circuits.UART.enumerate()

    found_by_manufacturer =
      Enum.filter(devices, fn {_, m} ->
        :manufacturer in Map.keys(m) and
          search_in_names(m.manufacturer, Application.get_env(:pi_dash, :supported_manufacturers))
      end)

    found_by_port_names =
      Enum.filter(devices, fn {port, _} ->
        search_in_names(port, Application.get_env(:pi_dash, :supported_serial_names))
      end)

    found = found_by_manufacturer ++ found_by_port_names

    cond do
      List.first(found) == nil -> {nil, devices}
      true -> List.first(found)
    end
  end

  defp search_in_names(item, list) do
    Enum.filter(list, fn e ->
      String.contains?(item, e)
    end)
  end
end
