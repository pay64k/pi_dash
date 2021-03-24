defmodule Obd.DataTranslator do
  require Logger

  def decode_data("") do
    :error
  end

  def decode_data(hex_string) do
    <<header::24, mode::8, pid::8, data_and_crc::binary>> = Base.decode16!(hex_string)
    # Logger.debug("decoded data for #{hex_string}:
    #    header: #{inspect(Base.encode16(<<header::24>>))}, mode: #{inspect(Base.encode16(<<mode::8>>))}, pid: #{inspect(Base.encode16(<<pid::8>>))}")

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
  def handle_data(:speed, <<a::8>>), do: a

  def handle_data(:engine_load, <<a::8, _crc>>), do: 100 / 255 * a
  def handle_data(:engine_load, <<a::8>>), do: 100 / 255 * a
  def handle_data(:engine_load, <<>>), do: 0

  def handle_data(:coolant_temp, <<a::8, _crc>>), do: a - 40
  def handle_data(:coolant_temp, <<a::8>>), do: a - 40

  def handle_data(:intake_temp, <<a::8, _crc>>), do: a - 40
  def handle_data(:intake_temp, <<a::8>>), do: a - 40

  def handle_data(:throttle_pos, <<a::8, _crc>>), do: 100 / 255 * a
  def handle_data(:throttle_pos, <<a::8>>), do: 100 / 255 * a
  def handle_data(:throttle_pos, <<>>), do: 0

  def handle_data(:timing_advance, <<a::8, _crc>>), do: a/2 - 64
  def handle_data(:timing_advance, <<a::8>>), do: a/2 -64

  def handle_data(_obd_pid, _data), do: {:error, :unhandled}

  def parse_supported_pids(hex_string) do
    {stream, offset} =
      hex_string
      |> Base.decode16!()
      |> extract_sup_pids_data()

    bits = ExBin.bits(stream)

    {_, supported_pids} =
      Enum.reduce(bits, {1, []}, fn bit, {count, acc} ->
        case bit do
          0 -> {count + 1, acc}
          1 -> {count + 1, acc ++ [convert_and_pad(count, offset)]}
        end
      end)

    supported_pids
  end

  def extract_sup_pids_data(<<_header::24, _mode::8, pid::8, data::32, _crc::binary>>) do
    {<<data::32>>, pid}
  end

  defp convert_and_pad(int, offset) do
    str = Integer.to_string(int + offset, 16)

    case String.length(str) do
      1 -> String.pad_leading(str, 2, "0")
      2 -> str
    end
  end
end
