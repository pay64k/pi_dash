defmodule DataTranslatorTest do
  use ExUnit.Case

  test "parsing supported pids hex string" do
    # example from https://en.wikipedia.org/wiki/OBD-II_PIDs#Service_01_PID_00
    headers = "486B10"
    mode = "41"
    pid = "00"
    data = "BE1FA813"
    crc = "C9"

    hex_string = headers <> mode <> pid <> data <> crc
    assert ["01", "03", "04", "05", "06", "07", "0C", "0D", "0E", "0F", "10", "11", "13", "15",
    "1C", "1F", "20"] == Obd.DataTranslator.parse_supported_pids(hex_string)
  end

end
