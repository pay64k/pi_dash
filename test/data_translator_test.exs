defmodule DataTranslatorTest do
  use ExUnit.Case

  test "parsing supported pids hex string" do
    assert ["BE", "1F", "A8", "13"] == Obd.DataTranslator.parse_supported_pids("BE1FA813")
  end

end
