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

  def parse_supported_pids(hex_string) do
    stream =
      hex_string
      |> Base.decode16!()
      |> ExBin.bits()

    {_, supported_pids} =
      Enum.reduce(stream, {1, []}, fn bit, {count, acc} ->
        case bit do
          0 -> {count + 1, acc}
          1 -> {count + 1, acc ++ [convert_and_pad(count)]}
        end
      end)

    supported_pids
  end

  defp convert_and_pad(int) do
    str = Integer.to_string(int, 16)

    case String.length(str) do
      1 -> String.pad_leading(str, 2, "0")
      2 -> str
    end
  end
end
