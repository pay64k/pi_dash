defmodule Obd.DataTranslator do
  require Logger

  def decode_data(hex_string) do
    <<_header::24, _mode::8, pid::8, data_and_crc::binary>> = Base.decode16!(hex_string)

    obd_pid_name =
      <<pid::8>>
      |> Base.encode16()
      |> Obd.PidTranslator.pid_to_name()

    %{obd_pid_name: obd_pid_name, data: data_and_crc}
  end

  def handle_data(%{data: data, obd_pid_name: obd_pid_name}) do
    handle_data(obd_pid_name, data)
  end

  def handle_data(:rpm, <<a::8, b::8, _crc>>), do: (256 * a + b) / 4
  def handle_data(:rpm, <<a::8, b::8>>), do: (256 * a + b) / 4
  def handle_data(:rpm, _), do: {:error, :malformed}

  def handle_data(:speed, <<a::8, _crc>>), do: a

  def handle_data(:engine_load, <<a::8, _crc>>), do: 100 / 255 * a
  def handle_data(:engine_load, <<>>), do: 0

  def handle_data(:coolant_temp, <<a::8, _crc>>), do: a - 40

  def handle_data(:intake_temp, <<a::8, _crc>>), do: a - 40

  def handle_data(:throttle_pos, <<a::8, _crc>>), do: 100 / 255 * a
  def handle_data(:throttle_pos, <<>>), do: 0

  def handle_data(_obd_pid, _data), do: {:error, :unhandled}

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
