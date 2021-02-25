defmodule Obd.PidTranslator do
  # from: https://python-obd.readthedocs.io/en/latest/Command%20Tables/

  def pid_info("PIDS_A"), do: {"Supported PIDs [01-20]", "bitarray"}
  def pid_info("STATUS"), do: {"Status since DTCs cleared", "special"}
  def pid_info("FREEZE_DTC"), do: {"DTC that triggered the freeze frame", "special"}
  def pid_info("FUEL_STATUS"), do: {"Fuel System Status", "string"}
  def pid_info("ENGINE_LOAD"), do: {"Calculated Engine Load", "percent"}
  def pid_info("COOLANT_TEMP"), do: {"Engine Coolant Temperature", "celsius"}
  def pid_info("SHORT_FUEL_TRIM_1"), do: {"Short Term Fuel Trim - Bank 1", "percent"}
  def pid_info("LONG_FUEL_TRIM_1"), do: {"Long Term Fuel Trim - Bank 1", "percent"}
  def pid_info("SHORT_FUEL_TRIM_2"), do: {"Short Term Fuel Trim - Bank 2", "percent"}
  def pid_info("LONG_FUEL_TRIM_2"), do: {"Long Term Fuel Trim - Bank 2", "percent"}
  def pid_info("FUEL_PRESSURE"), do: {"Fuel Pressure", "kilopascal"}
  def pid_info("INTAKE_PRESSURE"), do: {"Intake Manifold Pressure", "kilopascal"}
  def pid_info("RPM"), do: {"Engine RPM", "rpm"}
  def pid_info("SPEED"), do: {"Vehicle Speed", "kph"}
  def pid_info("TIMING_ADVANCE"), do: {"Timing Advance", "degree"}
  def pid_info("INTAKE_TEMP"), do: {"Intake Air Temp", "celsius"}
  def pid_info("MAF"), do: {"Air Flow Rate (MAF)", "grams_per_second"}
  def pid_info("THROTTLE_POS"), do: {"Throttle Position", "percent"}
  def pid_info("AIR_STATUS"), do: {"Secondary Air Status", "string"}
  def pid_info("O2_SENSORS"), do: {"O2 Sensors Present", "special"}
  def pid_info("O2_B1S1"), do: {"O2: Bank 1 - Sensor 1 Voltage", "volt"}
  def pid_info("O2_B1S2"), do: {"O2: Bank 1 - Sensor 2 Voltage", "volt"}
  def pid_info("O2_B1S3"), do: {"O2: Bank 1 - Sensor 3 Voltage", "volt"}
  def pid_info("O2_B1S4"), do: {"O2: Bank 1 - Sensor 4 Voltage", "volt"}
  def pid_info("O2_B2S1"), do: {"O2: Bank 2 - Sensor 1 Voltage", "volt"}
  def pid_info("O2_B2S2"), do: {"O2: Bank 2 - Sensor 2 Voltage", "volt"}
  def pid_info("O2_B2S3"), do: {"O2: Bank 2 - Sensor 3 Voltage", "volt"}
  def pid_info("O2_B2S4"), do: {"O2: Bank 2 - Sensor 4 Voltage", "volt"}
  def pid_info("OBD_COMPLIANCE"), do: {"OBD Standards Compliance", "string"}
  def pid_info("O2_SENSORS_ALT"), do: {"O2 Sensors Present (alternate)", "special"}
  def pid_info("AUX_INPUT_STATUS"), do: {"Auxiliary input status (power take, off)", "boolean"}
  def pid_info("RUN_TIME"), do: {"Engine Run Time", "second"}
  def pid_info("PIDS_B"), do: {"Supported PIDs [21-,40]", "bitarray"}
  def pid_info("DISTANCE_W_MIL"), do: {"Distance Traveled with MIL on", "kilometer"}
  def pid_info("FUEL_RAIL_PRESSURE_VAC"), do: {"Fuel Rail Pressure (relative to vacuum", "kilopascal"}
  def pid_info("FUEL_RAIL_PRESSURE_DIRECT"), do: {"Fuel Rail Pressure (direct inject", "kilopascal"}
  def pid_info("O2_S1_WR_VOLTAGE"), do: {"02 Sensor 1 WR Lambda Voltage", "volt"}
  def pid_info("O2_S2_WR_VOLTAGE"), do: {"02 Sensor 2 WR Lambda Voltage", "volt"}
  def pid_info("O2_S3_WR_VOLTAGE"), do: {"02 Sensor 3 WR Lambda Voltage", "volt"}
  def pid_info("O2_S4_WR_VOLTAGE"), do: {"02 Sensor 4 WR Lambda Voltage", "volt"}
  def pid_info("O2_S5_WR_VOLTAGE"), do: {"02 Sensor 5 WR Lambda Voltage", "volt"}
  def pid_info("O2_S6_WR_VOLTAGE"), do: {"02 Sensor 6 WR Lambda Voltage", "volt"}
  def pid_info("O2_S7_WR_VOLTAGE"), do: {"02 Sensor 7 WR Lambda Voltage", "volt"}
  def pid_info("O2_S8_WR_VOLTAGE"), do: {"02 Sensor 8 WR Lambda Voltage", "volt"}
  def pid_info("COMMANDED_EGR"), do: {"Commanded EGR", "percent"}
  def pid_info("EGR_ERROR"), do: {"EGR Error", "percent"}
  def pid_info("EVAPORATIVE_PURGE"), do: {"Commanded Evaporative Purge", "percent"}
  def pid_info("FUEL_LEVEL"), do: {"Fuel Level Input", "percent"}
  def pid_info("WARMUPS_SINCE_DTC_CLEAR"), do: {"Number of warm-ups since codes cleared", "count"}
  def pid_info("DISTANCE_SINCE_DTC_CLEAR"), do: {"Distance traveled since codes cleared", "kilometer"}
  def pid_info("EVAP_VAPOR_PRESSURE"), do: {"Evaporative system vapor pressure", "pascal"}
  def pid_info("BAROMETRIC_PRESSURE"), do: {"Barometric Pressure", "kilopascal"}
  def pid_info("O2_S1_WR_CURRENT"), do: {"02 Sensor 1 WR Lambda Current", "milliampere"}
  def pid_info("O2_S2_WR_CURRENT"), do: {"02 Sensor 2 WR Lambda Current", "milliampere"}
  def pid_info("O2_S3_WR_CURRENT"), do: {"02 Sensor 3 WR Lambda Current", "milliampere"}
  def pid_info("O2_S4_WR_CURRENT"), do: {"02 Sensor 4 WR Lambda Current", "milliampere"}
  def pid_info("O2_S5_WR_CURRENT"), do: {"02 Sensor 5 WR Lambda Current", "milliampere"}
  def pid_info("O2_S6_WR_CURRENT"), do: {"02 Sensor 6 WR Lambda Current", "milliampere"}
  def pid_info("O2_S7_WR_CURRENT"), do: {"02 Sensor 7 WR Lambda Current", "milliampere"}
  def pid_info("O2_S8_WR_CURRENT"), do: {"02 Sensor 8 WR Lambda Current", "milliampere"}
  def pid_info("CATALYST_TEMP_B1S1"), do: {"Catalyst Temperature: Bank 1 - Sensor 1", "celsius"}
  def pid_info("CATALYST_TEMP_B2S1"), do: {"Catalyst Temperature: Bank 2 - Sensor 1", "celsius"}
  def pid_info("CATALYST_TEMP_B1S2"), do: {"Catalyst Temperature: Bank 1 - Sensor 2", "celsius"}
  def pid_info("CATALYST_TEMP_B2S2"), do: {"Catalyst Temperature: Bank 2 - Sensor 2", "celsius"}
  def pid_info("PIDS_C"), do: {"Supported PIDs [41-60]", "bitarray"}
  def pid_info("STATUS_DRIVE_CYCLE"), do: {"Monitor status this drive cycle", "special"}
  def pid_info("CONTROL_MODULE_VOLTAGE"), do: {"Control module voltage", "volt"}
  def pid_info("ABSOLUTE_LOAD"), do: {"Absolute load value", "percent"}
  def pid_info("COMMANDED_EQUIV_RATIO"), do: {"Commanded equivalence ratio", "ratio"}
  def pid_info("RELATIVE_THROTTLE_POS"), do: {"Relative throttle position", "percent"}
  def pid_info("AMBIANT_AIR_TEMP"), do: {"Ambient air temperature", "celsius"}
  def pid_info("THROTTLE_POS_B"), do: {"Absolute throttle position B", "percent"}
  def pid_info("THROTTLE_POS_C"), do: {"Absolute throttle position C", "percent"}
  def pid_info("ACCELERATOR_POS_D"), do: {"Accelerator pedal position D", "percent"}
  def pid_info("ACCELERATOR_POS_E"), do: {"Accelerator pedal position E", "percent"}
  def pid_info("ACCELERATOR_POS_F"), do: {"Accelerator pedal position F", "percent"}
  def pid_info("THROTTLE_ACTUATOR"), do: {"Commanded throttle actuator", "percent"}
  def pid_info("RUN_TIME_MIL"), do: {"Time run with MIL on", "minute"}
  def pid_info("TIME_SINCE_DTC_CLEARED"), do: {"Time since trouble codes cleared", "minute"}
  def pid_info("MAX_MAF"), do: {"Maximum value for mass air flow sensor", "grams_per_second"}
  def pid_info("FUEL_TYPE"), do: {"Fuel Type", "string"}
  def pid_info("ETHANOL_PERCENT"), do: {"Ethanol Fuel Percent", "percent"}
  def pid_info("EVAP_VAPOR_PRESSURE_ABS"), do: {"Absolute Evap system Vapor Pressure", "kilopascal"}
  def pid_info("EVAP_VAPOR_PRESSURE_ALT"), do: {"Evap system vapor pressure", "pascal"}
  def pid_info("SHORT_O2_TRIM_B1"), do: {"Short term secondary O2 trim - Bank 1", "percent"}
  def pid_info("LONG_O2_TRIM_B1"), do: {"Long term secondary O2 trim - Bank 1", "percent"}
  def pid_info("SHORT_O2_TRIM_B2"), do: {"Short term secondary O2 trim - Bank 2", "percent"}
  def pid_info("LONG_O2_TRIM_B2"), do: {"Long term secondary O2 trim - Bank 2", "percent"}
  def pid_info("FUEL_RAIL_PRESSURE_ABS"), do: {"Fuel rail pressure (absolute)", "kilopascal"}
  def pid_info("RELATIVE_ACCEL_POS"), do: {"Relative accelerator pedal position", "percent"}
  def pid_info("HYBRID_BATTERY_REMAINING"), do: {"Hybrid battery pack remaining life", "percent"}
  def pid_info("OIL_TEMP"), do: {"Engine oil temperature", "celsius"}
  def pid_info("FUEL_INJECT_TIMING"), do: {"Fuel injection timing", "degree"}
  def pid_info("FUEL_RATE"), do: {"Engine fuel rate", "liters_per_hour"}

  def pid_to_name("00"), do: "PIDS_A"
  def pid_to_name("01"), do: "STATUS"
  def pid_to_name("02"), do: "FREEZE_DTC"
  def pid_to_name("03"), do: "FUEL_STATUS"
  def pid_to_name("04"), do: "ENGINE_LOAD"
  def pid_to_name("05"), do: "COOLANT_TEMP"
  def pid_to_name("06"), do: "SHORT_FUEL_TRIM_1"
  def pid_to_name("07"), do: "LONG_FUEL_TRIM_1"
  def pid_to_name("08"), do: "SHORT_FUEL_TRIM_2"
  def pid_to_name("09"), do: "LONG_FUEL_TRIM_2"
  def pid_to_name("0A"), do: "FUEL_PRESSURE"
  def pid_to_name("0B"), do: "INTAKE_PRESSURE"
  def pid_to_name("0C"), do: "RPM"
  def pid_to_name("0D"), do: "SPEED"
  def pid_to_name("0E"), do: "TIMING_ADVANCE"
  def pid_to_name("0F"), do: "INTAKE_TEMP"
  def pid_to_name("10"), do: "MAF"
  def pid_to_name("11"), do: "THROTTLE_POS"
  def pid_to_name("12"), do: "AIR_STATUS"
  def pid_to_name("13"), do: "O2_SENSORS"
  def pid_to_name("14"), do: "O2_B1S1"
  def pid_to_name("15"), do: "O2_B1S2"
  def pid_to_name("16"), do: "O2_B1S3"
  def pid_to_name("17"), do: "O2_B1S4"
  def pid_to_name("18"), do: "O2_B2S1"
  def pid_to_name("19"), do: "O2_B2S2"
  def pid_to_name("1A"), do: "O2_B2S3"
  def pid_to_name("1B"), do: "O2_B2S4"
  def pid_to_name("1C"), do: "OBD_COMPLIANCE"
  def pid_to_name("1D"), do: "O2_SENSORS_ALT"
  def pid_to_name("1E"), do: "AUX_INPUT_STATUS"
  def pid_to_name("1F"), do: "RUN_TIME"
  def pid_to_name("20"), do: "PIDS_B"
  def pid_to_name("21"), do: "DISTANCE_W_MIL"
  def pid_to_name("22"), do: "FUEL_RAIL_PRESSURE_VAC"
  def pid_to_name("23"), do: "FUEL_RAIL_PRESSURE_DIRECT"
  def pid_to_name("24"), do: "O2_S1_WR_VOLTAGE"
  def pid_to_name("25"), do: "O2_S2_WR_VOLTAGE"
  def pid_to_name("26"), do: "O2_S3_WR_VOLTAGE"
  def pid_to_name("27"), do: "O2_S4_WR_VOLTAGE"
  def pid_to_name("28"), do: "O2_S5_WR_VOLTAGE"
  def pid_to_name("29"), do: "O2_S6_WR_VOLTAGE"
  def pid_to_name("2A"), do: "O2_S7_WR_VOLTAGE"
  def pid_to_name("2B"), do: "O2_S8_WR_VOLTAGE"
  def pid_to_name("2C"), do: "COMMANDED_EGR"
  def pid_to_name("2D"), do: "EGR_ERROR"
  def pid_to_name("2E"), do: "EVAPORATIVE_PURGE"
  def pid_to_name("2F"), do: "FUEL_LEVEL"
  def pid_to_name("30"), do: "WARMUPS_SINCE_DTC_CLEAR"
  def pid_to_name("31"), do: "DISTANCE_SINCE_DTC_CLEAR"
  def pid_to_name("32"), do: "EVAP_VAPOR_PRESSURE"
  def pid_to_name("33"), do: "BAROMETRIC_PRESSURE"
  def pid_to_name("34"), do: "O2_S1_WR_CURRENT"
  def pid_to_name("35"), do: "O2_S2_WR_CURRENT"
  def pid_to_name("36"), do: "O2_S3_WR_CURRENT"
  def pid_to_name("37"), do: "O2_S4_WR_CURRENT"
  def pid_to_name("38"), do: "O2_S5_WR_CURRENT"
  def pid_to_name("39"), do: "O2_S6_WR_CURRENT"
  def pid_to_name("3A"), do: "O2_S7_WR_CURRENT"
  def pid_to_name("3B"), do: "O2_S8_WR_CURRENT"
  def pid_to_name("3C"), do: "CATALYST_TEMP_B1S1"
  def pid_to_name("3D"), do: "CATALYST_TEMP_B2S1"
  def pid_to_name("3E"), do: "CATALYST_TEMP_B1S2"
  def pid_to_name("3F"), do: "CATALYST_TEMP_B2S2"
  def pid_to_name("40"), do: "PIDS_C"
  def pid_to_name("41"), do: "STATUS_DRIVE_CYCLE"
  def pid_to_name("42"), do: "CONTROL_MODULE_VOLTAGE"
  def pid_to_name("43"), do: "ABSOLUTE_LOAD"
  def pid_to_name("44"), do: "COMMANDED_EQUIV_RATIO"
  def pid_to_name("45"), do: "RELATIVE_THROTTLE_POS"
  def pid_to_name("46"), do: "AMBIANT_AIR_TEMP"
  def pid_to_name("47"), do: "THROTTLE_POS_B"
  def pid_to_name("48"), do: "THROTTLE_POS_C"
  def pid_to_name("49"), do: "ACCELERATOR_POS_D"
  def pid_to_name("4A"), do: "ACCELERATOR_POS_E"
  def pid_to_name("4B"), do: "ACCELERATOR_POS_F"
  def pid_to_name("4C"), do: "THROTTLE_ACTUATOR"
  def pid_to_name("4D"), do: "RUN_TIME_MIL"
  def pid_to_name("4E"), do: "TIME_SINCE_DTC_CLEARED"
  def pid_to_name("4F"), do: "unsupported"
  def pid_to_name("50"), do: "MAX_MAF"
  def pid_to_name("51"), do: "FUEL_TYPE"
  def pid_to_name("52"), do: "ETHANOL_PERCENT"
  def pid_to_name("53"), do: "EVAP_VAPOR_PRESSURE_ABS"
  def pid_to_name("54"), do: "EVAP_VAPOR_PRESSURE_ALT"
  def pid_to_name("55"), do: "SHORT_O2_TRIM_B1"
  def pid_to_name("56"), do: "LONG_O2_TRIM_B1"
  def pid_to_name("57"), do: "SHORT_O2_TRIM_B2"
  def pid_to_name("58"), do: "LONG_O2_TRIM_B2"
  def pid_to_name("59"), do: "FUEL_RAIL_PRESSURE_ABS"
  def pid_to_name("5A"), do: "RELATIVE_ACCEL_POS"
  def pid_to_name("5B"), do: "HYBRID_BATTERY_REMAINING"
  def pid_to_name("5C"), do: "OIL_TEMP"
  def pid_to_name("5D"), do: "FUEL_INJECT_TIMING"
  def pid_to_name("5E"), do: "FUEL_RATE"
  def pid_to_name("5F"), do: "unsupported"
  def pid_to_name(_), do: :not_implemented

  def name_to_pid("PIDS_A"), do: "00"
  def name_to_pid("STATUS"), do: "01"
  def name_to_pid("FREEZE_DTC"), do: "02"
  def name_to_pid("FUEL_STATUS"), do: "03"
  def name_to_pid("ENGINE_LOAD"), do: "04"
  def name_to_pid("COOLANT_TEMP"), do: "05"
  def name_to_pid("SHORT_FUEL_TRIM_1"), do: "06"
  def name_to_pid("LONG_FUEL_TRIM_1"), do: "07"
  def name_to_pid("SHORT_FUEL_TRIM_2"), do: "08"
  def name_to_pid("LONG_FUEL_TRIM_2"), do: "09"
  def name_to_pid("FUEL_PRESSURE"), do: "0A"
  def name_to_pid("INTAKE_PRESSURE"), do: "0B"
  def name_to_pid("RPM"), do: "0C"
  def name_to_pid("SPEED"), do: "0D"
  def name_to_pid("TIMING_ADVANCE"), do: "0E"
  def name_to_pid("INTAKE_TEMP"), do: "0F"
  def name_to_pid("MAF"), do: "10"
  def name_to_pid("THROTTLE_POS"), do: "11"
  def name_to_pid("AIR_STATUS"), do: "12"
  def name_to_pid("O2_SENSORS"), do: "13"
  def name_to_pid("O2_B1S1"), do: "14"
  def name_to_pid("O2_B1S2"), do: "15"
  def name_to_pid("O2_B1S3"), do: "16"
  def name_to_pid("O2_B1S4"), do: "17"
  def name_to_pid("O2_B2S1"), do: "18"
  def name_to_pid("O2_B2S2"), do: "19"
  def name_to_pid("O2_B2S3"), do: "1A"
  def name_to_pid("O2_B2S4"), do: "1B"
  def name_to_pid("OBD_COMPLIANCE"), do: "1C"
  def name_to_pid("O2_SENSORS_ALT"), do: "1D"
  def name_to_pid("AUX_INPUT_STATUS"), do: "1E"
  def name_to_pid("RUN_TIME"), do: "1F"
  def name_to_pid("PIDS_B"), do: "20"
  def name_to_pid("DISTANCE_W_MIL"), do: "21"
  def name_to_pid("FUEL_RAIL_PRESSURE_VAC"), do: "22"
  def name_to_pid("FUEL_RAIL_PRESSURE_DIRECT"), do: "23"
  def name_to_pid("O2_S1_WR_VOLTAGE"), do: "24"
  def name_to_pid("O2_S2_WR_VOLTAGE"), do: "25"
  def name_to_pid("O2_S3_WR_VOLTAGE"), do: "26"
  def name_to_pid("O2_S4_WR_VOLTAGE"), do: "27"
  def name_to_pid("O2_S5_WR_VOLTAGE"), do: "28"
  def name_to_pid("O2_S6_WR_VOLTAGE"), do: "29"
  def name_to_pid("O2_S7_WR_VOLTAGE"), do: "2A"
  def name_to_pid("O2_S8_WR_VOLTAGE"), do: "2B"
  def name_to_pid("COMMANDED_EGR"), do: "2C"
  def name_to_pid("EGR_ERROR"), do: "2D"
  def name_to_pid("EVAPORATIVE_PURGE"), do: "2E"
  def name_to_pid("FUEL_LEVEL"), do: "2F"
  def name_to_pid("WARMUPS_SINCE_DTC_CLEAR"), do: "30"
  def name_to_pid("DISTANCE_SINCE_DTC_CLEAR"), do: "31"
  def name_to_pid("EVAP_VAPOR_PRESSURE"), do: "32"
  def name_to_pid("BAROMETRIC_PRESSURE"), do: "33"
  def name_to_pid("O2_S1_WR_CURRENT"), do: "34"
  def name_to_pid("O2_S2_WR_CURRENT"), do: "35"
  def name_to_pid("O2_S3_WR_CURRENT"), do: "36"
  def name_to_pid("O2_S4_WR_CURRENT"), do: "37"
  def name_to_pid("O2_S5_WR_CURRENT"), do: "38"
  def name_to_pid("O2_S6_WR_CURRENT"), do: "39"
  def name_to_pid("O2_S7_WR_CURRENT"), do: "3A"
  def name_to_pid("O2_S8_WR_CURRENT"), do: "3B"
  def name_to_pid("CATALYST_TEMP_B1S1"), do: "3C"
  def name_to_pid("CATALYST_TEMP_B2S1"), do: "3D"
  def name_to_pid("CATALYST_TEMP_B1S2"), do: "3E"
  def name_to_pid("CATALYST_TEMP_B2S2"), do: "3F"
  def name_to_pid("PIDS_C"), do: "40"
  def name_to_pid("STATUS_DRIVE_CYCLE"), do: "41"
  def name_to_pid("CONTROL_MODULE_VOLTAGE"), do: "42"
  def name_to_pid("ABSOLUTE_LOAD"), do: "43"
  def name_to_pid("COMMANDED_EQUIV_RATIO"), do: "44"
  def name_to_pid("RELATIVE_THROTTLE_POS"), do: "45"
  def name_to_pid("AMBIANT_AIR_TEMP"), do: "46"
  def name_to_pid("THROTTLE_POS_B"), do: "47"
  def name_to_pid("THROTTLE_POS_C"), do: "48"
  def name_to_pid("ACCELERATOR_POS_D"), do: "49"
  def name_to_pid("ACCELERATOR_POS_E"), do: "4A"
  def name_to_pid("ACCELERATOR_POS_F"), do: "4B"
  def name_to_pid("THROTTLE_ACTUATOR"), do: "4C"
  def name_to_pid("RUN_TIME_MIL"), do: "4D"
  def name_to_pid("TIME_SINCE_DTC_CLEARED"), do: "4E"
  def name_to_pid("MAX_MAF"), do: "50"
  def name_to_pid("FUEL_TYPE"), do: "51"
  def name_to_pid("ETHANOL_PERCENT"), do: "52"
  def name_to_pid("EVAP_VAPOR_PRESSURE_ABS"), do: "53"
  def name_to_pid("EVAP_VAPOR_PRESSURE_ALT"), do: "54"
  def name_to_pid("SHORT_O2_TRIM_B1"), do: "55"
  def name_to_pid("LONG_O2_TRIM_B1"), do: "56"
  def name_to_pid("SHORT_O2_TRIM_B2"), do: "57"
  def name_to_pid("LONG_O2_TRIM_B2"), do: "58"
  def name_to_pid("FUEL_RAIL_PRESSURE_ABS"), do: "59"
  def name_to_pid("RELATIVE_ACCEL_POS"), do: "5A"
  def name_to_pid("HYBRID_BATTERY_REMAINING"), do: "5B"
  def name_to_pid("OIL_TEMP"), do: "5C"
  def name_to_pid("FUEL_INJECT_TIMING"), do: "5D"
  def name_to_pid("FUEL_RATE"), do: "5E"
  def name_to_pid(_), do: :not_implemented
end
