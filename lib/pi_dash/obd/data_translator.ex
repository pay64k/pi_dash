defmodule Obd.DataTranslator do

  # rpm
  def handle_data(12, <<a, b>>) do
    {(256 * a + b)/4, "RPM"}
  end

  # vehicle speed
  def handle_data(13, <<a>>) do
    {a, "km/h"}
  end

  def handle_data(obd_pid, data) do
    IO.puts "unhandled pid #{obd_pid}, data: #{data}"
  end

end
