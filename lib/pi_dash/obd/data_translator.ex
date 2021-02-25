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

  def parse_supported_pids(msg) do
    split_string(msg)
  end

  defp split_string(str) do
    split_string(str,[])
  end

  defp split_string("", acc), do: acc
  defp split_string(str, acc) do
    {s, rest} = String.split_at(str, 2)
    split_string(rest, acc ++ [s])
  end

end
