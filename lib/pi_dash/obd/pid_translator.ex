defmodule Obd.PidTranslator do
  # from: https://python-obd.readthedocs.io/en/latest/Command%20Tables/

  def pid_info(:pids_a), do: {"Supported PIDs [01-20]", "bitarray"}
  def pid_info(:status), do: {"Status since DTCs cleared", "special"}
  def pid_info(:freeze_dtc), do: {"DTC that triggered the freeze frame", "special"}
  def pid_info(:fuel_status), do: {"Fuel System Status", "string"}
  def pid_info(:engine_load), do: {"Calculated Engine Load", "percent"}
  def pid_info(:coolant_temp), do: {"Engine Coolant Temperature", "celsius"}
  def pid_info(:short_fuel_trim_1), do: {"Short Term Fuel Trim - Bank 1", "percent"}
  def pid_info(:long_fuel_trim_1), do: {"Long Term Fuel Trim - Bank 1", "percent"}
  def pid_info(:short_fuel_trim_2), do: {"Short Term Fuel Trim - Bank 2", "percent"}
  def pid_info(:long_fuel_trim_2), do: {"Long Term Fuel Trim - Bank 2", "percent"}
  def pid_info(:fuel_pressure), do: {"Fuel Pressure", "kilopascal"}
  def pid_info(:intake_pressure), do: {"Intake Manifold Pressure", "kilopascal"}
  def pid_info(:rpm), do: {"Engine RPM", "rpm"}
  def pid_info(:speed), do: {"Vehicle Speed", "kph"}
  def pid_info(:timing_advance), do: {"Timing Advance", "degree"}
  def pid_info(:intake_temp), do: {"Intake Air Temp", "celsius"}
  def pid_info(:maf), do: {"Air Flow Rate (MAF)", "grams_per_second"}
  def pid_info(:throttle_pos), do: {"Throttle Position", "percent"}
  def pid_info(:air_status), do: {"Secondary Air Status", "string"}
  def pid_info(:o2_sensors), do: {"O2 Sensors Present", "special"}
  def pid_info(:o2_b1s1), do: {"O2: Bank 1 - Sensor 1 Voltage", "volt"}
  def pid_info(:o2_b1s2), do: {"O2: Bank 1 - Sensor 2 Voltage", "volt"}
  def pid_info(:o2_b1s3), do: {"O2: Bank 1 - Sensor 3 Voltage", "volt"}
  def pid_info(:o2_b1s4), do: {"O2: Bank 1 - Sensor 4 Voltage", "volt"}
  def pid_info(:o2_b2s1), do: {"O2: Bank 2 - Sensor 1 Voltage", "volt"}
  def pid_info(:o2_b2s2), do: {"O2: Bank 2 - Sensor 2 Voltage", "volt"}
  def pid_info(:o2_b2s3), do: {"O2: Bank 2 - Sensor 3 Voltage", "volt"}
  def pid_info(:o2_b2s4), do: {"O2: Bank 2 - Sensor 4 Voltage", "volt"}
  def pid_info(:obd_compliance), do: {"OBD Standards Compliance", "string"}
  def pid_info(:o2_sensors_alt), do: {"O2 Sensors Present (alternate)", "special"}
  def pid_info(:aux_input_status), do: {"Auxiliary input status (power take, off)", "boolean"}
  def pid_info(:run_time), do: {"Engine Run Time", "second"}
  def pid_info(:pids_b), do: {"Supported PIDs [21-,40]", "bitarray"}
  def pid_info(:distance_w_mil), do: {"Distance Traveled with MIL on", "kilometer"}
  def pid_info(:fuel_rail_pressure_vac), do: {"Fuel Rail Pressure (relative to vacuum", "kilopascal"}
  def pid_info(:fuel_rail_pressure_direct), do: {"Fuel Rail Pressure (direct inject", "kilopascal"}
  def pid_info(:o2_s1_wr_voltage), do: {"02 Sensor 1 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s2_wr_voltage), do: {"02 Sensor 2 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s3_wr_voltage), do: {"02 Sensor 3 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s4_wr_voltage), do: {"02 Sensor 4 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s5_wr_voltage), do: {"02 Sensor 5 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s6_wr_voltage), do: {"02 Sensor 6 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s7_wr_voltage), do: {"02 Sensor 7 WR Lambda Voltage", "volt"}
  def pid_info(:o2_s8_wr_voltage), do: {"02 Sensor 8 WR Lambda Voltage", "volt"}
  def pid_info(:commanded_egr), do: {"Commanded EGR", "percent"}
  def pid_info(:egr_error), do: {"EGR Error", "percent"}
  def pid_info(:evaporative_purge), do: {"Commanded Evaporative Purge", "percent"}
  def pid_info(:fuel_level), do: {"Fuel Level Input", "percent"}
  def pid_info(:warmups_since_dtc_clear), do: {"Number of warm-ups since codes cleared", "count"}
  def pid_info(:distance_since_dtc_clear), do: {"Distance traveled since codes cleared", "kilometer"}
  def pid_info(:evap_vapor_pressure), do: {"Evaporative system vapor pressure", "pascal"}
  def pid_info(:barometric_pressure), do: {"Barometric Pressure", "kilopascal"}
  def pid_info(:o2_s1_wr_current), do: {"02 Sensor 1 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s2_wr_current), do: {"02 Sensor 2 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s3_wr_current), do: {"02 Sensor 3 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s4_wr_current), do: {"02 Sensor 4 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s5_wr_current), do: {"02 Sensor 5 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s6_wr_current), do: {"02 Sensor 6 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s7_wr_current), do: {"02 Sensor 7 WR Lambda Current", "milliampere"}
  def pid_info(:o2_s8_wr_current), do: {"02 Sensor 8 WR Lambda Current", "milliampere"}
  def pid_info(:catalyst_temp_b1s1), do: {"Catalyst Temperature: Bank 1 - Sensor 1", "celsius"}
  def pid_info(:catalyst_temp_b2s1), do: {"Catalyst Temperature: Bank 2 - Sensor 1", "celsius"}
  def pid_info(:catalyst_temp_b1s2), do: {"Catalyst Temperature: Bank 1 - Sensor 2", "celsius"}
  def pid_info(:catalyst_temp_b2s2), do: {"Catalyst Temperature: Bank 2 - Sensor 2", "celsius"}
  def pid_info(:pids_c), do: {"Supported PIDs [41-60]", "bitarray"}
  def pid_info(:status_drive_cycle), do: {"Monitor status this drive cycle", "special"}
  def pid_info(:control_module_voltage), do: {"Control module voltage", "volt"}
  def pid_info(:absolute_load), do: {"Absolute load value", "percent"}
  def pid_info(:commanded_equiv_ratio), do: {"Commanded equivalence ratio", "ratio"}
  def pid_info(:relative_throttle_pos), do: {"Relative throttle position", "percent"}
  def pid_info(:ambiant_air_temp), do: {"Ambient air temperature", "celsius"}
  def pid_info(:throttle_pos_b), do: {"Absolute throttle position B", "percent"}
  def pid_info(:throttle_pos_c), do: {"Absolute throttle position C", "percent"}
  def pid_info(:accelerator_pos_d), do: {"Accelerator pedal position D", "percent"}
  def pid_info(:accelerator_pos_e), do: {"Accelerator pedal position E", "percent"}
  def pid_info(:accelerator_pos_f), do: {"Accelerator pedal position F", "percent"}
  def pid_info(:throttle_actuator), do: {"Commanded throttle actuator", "percent"}
  def pid_info(:run_time_mil), do: {"Time run with MIL on", "minute"}
  def pid_info(:time_since_dtc_cleared), do: {"Time since trouble codes cleared", "minute"}
  def pid_info(:max_maf), do: {"Maximum value for mass air flow sensor", "grams_per_second"}
  def pid_info(:fuel_type), do: {"Fuel Type", "string"}
  def pid_info(:ethanol_percent), do: {"Ethanol Fuel Percent", "percent"}
  def pid_info(:evap_vapor_pressure_abs), do: {"Absolute Evap system Vapor Pressure", "kilopascal"}
  def pid_info(:evap_vapor_pressure_alt), do: {"Evap system vapor pressure", "pascal"}
  def pid_info(:short_o2_trim_b1), do: {"Short term secondary O2 trim - Bank 1", "percent"}
  def pid_info(:long_o2_trim_b1), do: {"Long term secondary O2 trim - Bank 1", "percent"}
  def pid_info(:short_o2_trim_b2), do: {"Short term secondary O2 trim - Bank 2", "percent"}
  def pid_info(:long_o2_trim_b2), do: {"Long term secondary O2 trim - Bank 2", "percent"}
  def pid_info(:fuel_rail_pressure_abs), do: {"Fuel rail pressure (absolute)", "kilopascal"}
  def pid_info(:relative_accel_pos), do: {"Relative accelerator pedal position", "percent"}
  def pid_info(:hybrid_battery_remaining), do: {"Hybrid battery pack remaining life", "percent"}
  def pid_info(:oil_temp), do: {"Engine oil temperature", "celsius"}
  def pid_info(:fuel_inject_timing), do: {"Fuel injection timing", "degree"}
  def pid_info(:fuel_rate), do: {"Engine fuel rate", "liters_per_hour"}

  def pid_to_name("00"), do: :pids_a
  def pid_to_name("01"), do: :status
  def pid_to_name("02"), do: :freeze_dtc
  def pid_to_name("03"), do: :fuel_status
  def pid_to_name("04"), do: :engine_load
  def pid_to_name("05"), do: :coolant_temp
  def pid_to_name("06"), do: :short_fuel_trim_1
  def pid_to_name("07"), do: :long_fuel_trim_1
  def pid_to_name("08"), do: :short_fuel_trim_2
  def pid_to_name("09"), do: :long_fuel_trim_2
  def pid_to_name("0A"), do: :fuel_pressure
  def pid_to_name("0B"), do: :intake_pressure
  def pid_to_name("0C"), do: :rpm
  def pid_to_name("0D"), do: :speed
  def pid_to_name("0E"), do: :timing_advance
  def pid_to_name("0F"), do: :intake_temp
  def pid_to_name("10"), do: :maf
  def pid_to_name("11"), do: :throttle_pos
  def pid_to_name("12"), do: :air_status
  def pid_to_name("13"), do: :o2_sensors
  def pid_to_name("14"), do: :o2_b1s1
  def pid_to_name("15"), do: :o2_b1s2
  def pid_to_name("16"), do: :o2_b1s3
  def pid_to_name("17"), do: :o2_b1s4
  def pid_to_name("18"), do: :o2_b2s1
  def pid_to_name("19"), do: :o2_b2s2
  def pid_to_name("1A"), do: :o2_b2s3
  def pid_to_name("1B"), do: :o2_b2s4
  def pid_to_name("1C"), do: :obd_compliance
  def pid_to_name("1D"), do: :o2_sensors_alt
  def pid_to_name("1E"), do: :aux_input_status
  def pid_to_name("1F"), do: :run_time
  def pid_to_name("20"), do: :pids_b
  def pid_to_name("21"), do: :distance_w_mil
  def pid_to_name("22"), do: :fuel_rail_pressure_vac
  def pid_to_name("23"), do: :fuel_rail_pressure_direct
  def pid_to_name("24"), do: :o2_s1_wr_voltage
  def pid_to_name("25"), do: :o2_s2_wr_voltage
  def pid_to_name("26"), do: :o2_s3_wr_voltage
  def pid_to_name("27"), do: :o2_s4_wr_voltage
  def pid_to_name("28"), do: :o2_s5_wr_voltage
  def pid_to_name("29"), do: :o2_s6_wr_voltage
  def pid_to_name("2A"), do: :o2_s7_wr_voltage
  def pid_to_name("2B"), do: :o2_s8_wr_voltage
  def pid_to_name("2C"), do: :commanded_egr
  def pid_to_name("2D"), do: :egr_error
  def pid_to_name("2E"), do: :evaporative_purge
  def pid_to_name("2F"), do: :fuel_level
  def pid_to_name("30"), do: :warmups_since_dtc_clear
  def pid_to_name("31"), do: :distance_since_dtc_clear
  def pid_to_name("32"), do: :evap_vapor_pressure
  def pid_to_name("33"), do: :barometric_pressure
  def pid_to_name("34"), do: :o2_s1_wr_current
  def pid_to_name("35"), do: :o2_s2_wr_current
  def pid_to_name("36"), do: :o2_s3_wr_current
  def pid_to_name("37"), do: :o2_s4_wr_current
  def pid_to_name("38"), do: :o2_s5_wr_current
  def pid_to_name("39"), do: :o2_s6_wr_current
  def pid_to_name("3A"), do: :o2_s7_wr_current
  def pid_to_name("3B"), do: :o2_s8_wr_current
  def pid_to_name("3C"), do: :catalyst_temp_b1s1
  def pid_to_name("3D"), do: :catalyst_temp_b2s1
  def pid_to_name("3E"), do: :catalyst_temp_b1s2
  def pid_to_name("3F"), do: :catalyst_temp_b2s2
  def pid_to_name("40"), do: :pids_c
  def pid_to_name("41"), do: :status_drive_cycle
  def pid_to_name("42"), do: :control_module_voltage
  def pid_to_name("43"), do: :absolute_load
  def pid_to_name("44"), do: :commanded_equiv_ratio
  def pid_to_name("45"), do: :relative_throttle_pos
  def pid_to_name("46"), do: :ambiant_air_temp
  def pid_to_name("47"), do: :throttle_pos_b
  def pid_to_name("48"), do: :throttle_pos_c
  def pid_to_name("49"), do: :accelerator_pos_d
  def pid_to_name("4A"), do: :accelerator_pos_e
  def pid_to_name("4B"), do: :accelerator_pos_f
  def pid_to_name("4C"), do: :throttle_actuator
  def pid_to_name("4D"), do: :run_time_mil
  def pid_to_name("4E"), do: :time_since_dtc_cleared
  def pid_to_name("4F"), do: :unsupported
  def pid_to_name("50"), do: :max_maf
  def pid_to_name("51"), do: :fuel_type
  def pid_to_name("52"), do: :ethanol_percent
  def pid_to_name("53"), do: :evap_vapor_pressure_abs
  def pid_to_name("54"), do: :evap_vapor_pressure_alt
  def pid_to_name("55"), do: :short_o2_trim_b1
  def pid_to_name("56"), do: :long_o2_trim_b1
  def pid_to_name("57"), do: :short_o2_trim_b2
  def pid_to_name("58"), do: :long_o2_trim_b2
  def pid_to_name("59"), do: :fuel_rail_pressure_abs
  def pid_to_name("5A"), do: :relative_accel_pos
  def pid_to_name("5B"), do: :hybrid_battery_remaining
  def pid_to_name("5C"), do: :oil_temp
  def pid_to_name("5D"), do: :fuel_inject_timing
  def pid_to_name("5E"), do: :fuel_rate
  def pid_to_name("5F"), do: :unsupported
  def pid_to_name(_), do: :not_implemented

  def name_to_pid(:pids_a), do: "00"
  def name_to_pid(:status), do: "01"
  def name_to_pid(:freeze_dtc), do: "02"
  def name_to_pid(:fuel_status), do: "03"
  def name_to_pid(:engine_load), do: "04"
  def name_to_pid(:coolant_temp), do: "05"
  def name_to_pid(:short_fuel_trim_1), do: "06"
  def name_to_pid(:long_fuel_trim_1), do: "07"
  def name_to_pid(:short_fuel_trim_2), do: "08"
  def name_to_pid(:long_fuel_trim_2), do: "09"
  def name_to_pid(:fuel_pressure), do: "0A"
  def name_to_pid(:intake_pressure), do: "0B"
  def name_to_pid(:rpm), do: "0C"
  def name_to_pid(:speed), do: "0D"
  def name_to_pid(:timing_advance), do: "0E"
  def name_to_pid(:intake_temp), do: "0F"
  def name_to_pid(:maf), do: "10"
  def name_to_pid(:throttle_pos), do: "11"
  def name_to_pid(:air_status), do: "12"
  def name_to_pid(:o2_sensors), do: "13"
  def name_to_pid(:o2_b1s1), do: "14"
  def name_to_pid(:o2_b1s2), do: "15"
  def name_to_pid(:o2_b1s3), do: "16"
  def name_to_pid(:o2_b1s4), do: "17"
  def name_to_pid(:o2_b2s1), do: "18"
  def name_to_pid(:o2_b2s2), do: "19"
  def name_to_pid(:o2_b2s3), do: "1A"
  def name_to_pid(:o2_b2s4), do: "1B"
  def name_to_pid(:obd_compliance), do: "1C"
  def name_to_pid(:o2_sensors_alt), do: "1D"
  def name_to_pid(:aux_input_status), do: "1E"
  def name_to_pid(:run_time), do: "1F"
  def name_to_pid(:pids_b), do: "20"
  def name_to_pid(:distance_w_mil), do: "21"
  def name_to_pid(:fuel_rail_pressure_vac), do: "22"
  def name_to_pid(:fuel_rail_pressure_direct), do: "23"
  def name_to_pid(:o2_s1_wr_voltage), do: "24"
  def name_to_pid(:o2_s2_wr_voltage), do: "25"
  def name_to_pid(:o2_s3_wr_voltage), do: "26"
  def name_to_pid(:o2_s4_wr_voltage), do: "27"
  def name_to_pid(:o2_s5_wr_voltage), do: "28"
  def name_to_pid(:o2_s6_wr_voltage), do: "29"
  def name_to_pid(:o2_s7_wr_voltage), do: "2A"
  def name_to_pid(:o2_s8_wr_voltage), do: "2B"
  def name_to_pid(:commanded_egr), do: "2C"
  def name_to_pid(:egr_error), do: "2D"
  def name_to_pid(:evaporative_purge), do: "2E"
  def name_to_pid(:fuel_level), do: "2F"
  def name_to_pid(:warmups_since_dtc_clear), do: "30"
  def name_to_pid(:distance_since_dtc_clear), do: "31"
  def name_to_pid(:evap_vapor_pressure), do: "32"
  def name_to_pid(:barometric_pressure), do: "33"
  def name_to_pid(:o2_s1_wr_current), do: "34"
  def name_to_pid(:o2_s2_wr_current), do: "35"
  def name_to_pid(:o2_s3_wr_current), do: "36"
  def name_to_pid(:o2_s4_wr_current), do: "37"
  def name_to_pid(:o2_s5_wr_current), do: "38"
  def name_to_pid(:o2_s6_wr_current), do: "39"
  def name_to_pid(:o2_s7_wr_current), do: "3A"
  def name_to_pid(:o2_s8_wr_current), do: "3B"
  def name_to_pid(:catalyst_temp_b1s1), do: "3C"
  def name_to_pid(:catalyst_temp_b2s1), do: "3D"
  def name_to_pid(:catalyst_temp_b1s2), do: "3E"
  def name_to_pid(:catalyst_temp_b2s2), do: "3F"
  def name_to_pid(:pids_c), do: "40"
  def name_to_pid(:status_drive_cycle), do: "41"
  def name_to_pid(:control_module_voltage), do: "42"
  def name_to_pid(:absolute_load), do: "43"
  def name_to_pid(:commanded_equiv_ratio), do: "44"
  def name_to_pid(:relative_throttle_pos), do: "45"
  def name_to_pid(:ambiant_air_temp), do: "46"
  def name_to_pid(:throttle_pos_b), do: "47"
  def name_to_pid(:throttle_pos_c), do: "48"
  def name_to_pid(:accelerator_pos_d), do: "49"
  def name_to_pid(:accelerator_pos_e), do: "4A"
  def name_to_pid(:accelerator_pos_f), do: "4B"
  def name_to_pid(:throttle_actuator), do: "4C"
  def name_to_pid(:run_time_mil), do: "4D"
  def name_to_pid(:time_since_dtc_cleared), do: "4E"
  def name_to_pid(:max_maf), do: "50"
  def name_to_pid(:fuel_type), do: "51"
  def name_to_pid(:ethanol_percent), do: "52"
  def name_to_pid(:evap_vapor_pressure_abs), do: "53"
  def name_to_pid(:evap_vapor_pressure_alt), do: "54"
  def name_to_pid(:short_o2_trim_b1), do: "55"
  def name_to_pid(:long_o2_trim_b1), do: "56"
  def name_to_pid(:short_o2_trim_b2), do: "57"
  def name_to_pid(:long_o2_trim_b2), do: "58"
  def name_to_pid(:fuel_rail_pressure_abs), do: "59"
  def name_to_pid(:relative_accel_pos), do: "5A"
  def name_to_pid(:hybrid_battery_remaining), do: "5B"
  def name_to_pid(:oil_temp), do: "5C"
  def name_to_pid(:fuel_inject_timing), do: "5D"
  def name_to_pid(:fuel_rate), do: "5E"
  def name_to_pid(_), do: :not_implemented
end
