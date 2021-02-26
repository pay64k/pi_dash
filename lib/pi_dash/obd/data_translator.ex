defmodule Obd.DataTranslator do
  require Logger

  def decode_data(hex_string) do
    <<_header::24, _mode::8, pid::8, data_and_crc::binary>> = Base.decode16!(hex_string)
    %{data: data_and_crc, pid: pid}
  end

  def handle_data(%{data: data, pid: int_obd_pid}) do
    # pid to name
    # change handle data from int to atoms
    # Obd.PidTranslator()
  end

  # rpm
  def handle_data(12, <<a, b, _crc>>) do
    {(256 * a + b) / 4, "RPM"}
  end

  def handle_data(12, <<a, b>>) do
    {(256 * a + b) / 4, "RPM"}
  end

  def handle_data(12, <<_a>>) do
    {:error, :malformed}
  end

  # vehicle speed
  def handle_data(13, <<a, _crc>>) do
    {a, "km/h"}
  end

  def handle_data(_obd_pid, _data) do
    {:error, :unhandled}
  end

  def parse_supported_pids(hex_string) do
    stream =
      hex_string
      |> Base.decode16!()
      |> extract_sup_pids_data()
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

  def extract_sup_pids_data(<<_header::24, _mode::8, _pid::8, data::32, _crc::8>>) do
    <<data::32>>
  end

  defp convert_and_pad(int) do
    str = Integer.to_string(int, 16)

    case String.length(str) do
      1 -> String.pad_leading(str, 2, "0")
      2 -> str
    end
  end
end
