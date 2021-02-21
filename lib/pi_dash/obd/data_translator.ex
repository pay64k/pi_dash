defmodule Obd.DataTranslator do
  require Logger
  # rpm
  def handle_data(12, <<a, b, _>>) do
    {(256 * a + b) / 4, "RPM"}
  end

  def handle_data(12, <<a, b>>) do
    {(256 * a + b) / 4, "RPM"}
  end

  def handle_data(12, <<_a>>) do
    {:error, :malformed}
  end

  # vehicle speed
  def handle_data(13, <<a, _>>) do
    {a, "km/h"}
  end

  def handle_data(_obd_pid, _data) do
    {:error, :unhandled}
  end
end
