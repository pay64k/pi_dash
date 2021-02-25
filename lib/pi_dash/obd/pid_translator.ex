defmodule Obd.PidTranslator do
  # from: https://python-obd.readthedocs.io/en/latest/Command%20Tables/

  @mode_01 "01" # Show current data

  def pid_to_name(@mode_01, "00"), do: {"PIDS_A", "Supported PIDs [01-20]", "bitarray"}
  def pid_to_name(@mode_01, "01"), do: {"STATUS", "Status since DTCs cleared", "special"}
  def pid_to_name(@mode_01, "02"), do: {"FREEZE_DTC", "DTC that triggered the freeze frame", "special"}
  def pid_to_name(@mode_01, "03"), do: {"FUEL_STATUS", "Fuel System Status", "string"}
  def pid_to_name(@mode_01, "04"), do: {"ENGINE_LOAD", "Calculated Engine Load", "Unit.percent"}
  def pid_to_name(@mode_01, "05"), do: {"COOLANT_TEMP", "Engine Coolant Temperature", "Unit.celsius"}
  def pid_to_name(@mode_01, "06"), do: {"SHORT_FUEL_TRIM_1", "Short Term Fuel Trim - Bank 1", "Unit.percent"}
  def pid_to_name(@mode_01, "07"), do: {"LONG_FUEL_TRIM_1", "Long Term Fuel Trim - Bank 1", "Unit.percent"}
  def pid_to_name(@mode_01, "08"), do: {"SHORT_FUEL_TRIM_2", "Short Term Fuel Trim - Bank 2", "Unit.percent"}
  def pid_to_name(@mode_01, "09"), do: {"LONG_FUEL_TRIM_2", "Long Term Fuel Trim - Bank 2", "Unit.percent"}
  def pid_to_name(@mode_01, "0A"), do: {"FUEL_PRESSURE", "Fuel Pressure", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "0B"), do: {"INTAKE_PRESSURE", "Intake Manifold Pressure", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "0C"), do: {"RPM", "Engine RPM", "Unit.rpm"}
  def pid_to_name(@mode_01, "0D"), do: {"SPEED", "Vehicle Speed", "Unit.kph"}
  def pid_to_name(@mode_01, "0E"), do: {"TIMING_ADVANCE", "Timing Advance", "Unit.degree"}
  def pid_to_name(@mode_01, "0F"), do: {"INTAKE_TEMP", "Intake Air Temp", "Unit.celsius"}
  def pid_to_name(@mode_01, "10"), do: {"MAF", "Air Flow Rate (MAF)", "Unit.grams_per_second"}
  def pid_to_name(@mode_01, "11"), do: {"THROTTLE_POS", "Throttle Position", "Unit.percent"}
  def pid_to_name(@mode_01, "12"), do: {"AIR_STATUS", "Secondary Air Status", "string"}
  def pid_to_name(@mode_01, "13"), do: {"O2_SENSORS", "O2 Sensors Present", "special"}
  def pid_to_name(@mode_01, "14"), do: {"O2_B1S1", "O2: Bank 1 - Sensor 1 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "15"), do: {"O2_B1S2", "O2: Bank 1 - Sensor 2 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "16"), do: {"O2_B1S3", "O2: Bank 1 - Sensor 3 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "17"), do: {"O2_B1S4", "O2: Bank 1 - Sensor 4 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "18"), do: {"O2_B2S1", "O2: Bank 2 - Sensor 1 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "19"), do: {"O2_B2S2", "O2: Bank 2 - Sensor 2 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "1A"), do: {"O2_B2S3", "O2: Bank 2 - Sensor 3 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "1B"), do: {"O2_B2S4", "O2: Bank 2 - Sensor 4 Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "1C"), do: {"OBD_COMPLIANCE", "OBD Standards Compliance", "string"}
  def pid_to_name(@mode_01, "1D"), do: {"O2_SENSORS_ALT", "O2 Sensors Present (alternate)", "special"}
  def pid_to_name(@mode_01, "1E"), do: {"AUX_INPUT_STATUS", "Auxiliary input status (power take, off)", "boolean"}
  def pid_to_name(@mode_01, "1F"), do: {"RUN_TIME", "Engine Run Time", "Unit.second"}
  def pid_to_name(@mode_01, "20"), do: {"PIDS_B", "Supported PIDs [21-,40]", "bitarray"}
  def pid_to_name(@mode_01, "21"), do: {"DISTANCE_W_MIL", "Distance Traveled with MIL on", "Unit.kilometer"}
  def pid_to_name(@mode_01, "22"), do: {"FUEL_RAIL_PRESSURE_VAC", "Fuel Rail Pressure (relative to vacuum", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "23"), do: {"FUEL_RAIL_PRESSURE_DIRECT", "Fuel Rail Pressure (direct inject", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "24"), do: {"O2_S1_WR_VOLTAGE", "02 Sensor 1 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "25"), do: {"O2_S2_WR_VOLTAGE", "02 Sensor 2 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "26"), do: {"O2_S3_WR_VOLTAGE", "02 Sensor 3 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "27"), do: {"O2_S4_WR_VOLTAGE", "02 Sensor 4 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "28"), do: {"O2_S5_WR_VOLTAGE", "02 Sensor 5 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "29"), do: {"O2_S6_WR_VOLTAGE", "02 Sensor 6 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "2A"), do: {"O2_S7_WR_VOLTAGE", "02 Sensor 7 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "2B"), do: {"O2_S8_WR_VOLTAGE", "02 Sensor 8 WR Lambda Voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "2C"), do: {"COMMANDED_EGR", "Commanded EGR", "Unit.percent"}
  def pid_to_name(@mode_01, "2D"), do: {"EGR_ERROR", "EGR Error", "Unit.percent"}
  def pid_to_name(@mode_01, "2E"), do: {"EVAPORATIVE_PURGE", "Commanded Evaporative Purge", "Unit.percent"}
  def pid_to_name(@mode_01, "2F"), do: {"FUEL_LEVEL", "Fuel Level Input", "Unit.percent"}
  def pid_to_name(@mode_01, "30"), do: {"WARMUPS_SINCE_DTC_CLEAR", "Number of warm-ups since codes cleared", "Unit.count"}
  def pid_to_name(@mode_01, "31"), do: {"DISTANCE_SINCE_DTC_CLEAR", "Distance traveled since codes cleared", "Unit.kilometer"}
  def pid_to_name(@mode_01, "32"), do: {"EVAP_VAPOR_PRESSURE", "Evaporative system vapor pressure", "Unit.pascal"}
  def pid_to_name(@mode_01, "33"), do: {"BAROMETRIC_PRESSURE", "Barometric Pressure", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "34"), do: {"O2_S1_WR_CURRENT", "02 Sensor 1 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "35"), do: {"O2_S2_WR_CURRENT", "02 Sensor 2 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "36"), do: {"O2_S3_WR_CURRENT", "02 Sensor 3 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "37"), do: {"O2_S4_WR_CURRENT", "02 Sensor 4 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "38"), do: {"O2_S5_WR_CURRENT", "02 Sensor 5 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "39"), do: {"O2_S6_WR_CURRENT", "02 Sensor 6 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "3A"), do: {"O2_S7_WR_CURRENT", "02 Sensor 7 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "3B"), do: {"O2_S8_WR_CURRENT", "02 Sensor 8 WR Lambda Current", "Unit.milliampere"}
  def pid_to_name(@mode_01, "3C"), do: {"CATALYST_TEMP_B1S1", "Catalyst Temperature: Bank 1 - Sensor 1", "Unit.celsius"}
  def pid_to_name(@mode_01, "3D"), do: {"CATALYST_TEMP_B2S1", "Catalyst Temperature: Bank 2 - Sensor 1", "Unit.celsius"}
  def pid_to_name(@mode_01, "3E"), do: {"CATALYST_TEMP_B1S2", "Catalyst Temperature: Bank 1 - Sensor 2", "Unit.celsius"}
  def pid_to_name(@mode_01, "3F"), do: {"CATALYST_TEMP_B2S2", "Catalyst Temperature: Bank 2 - Sensor 2", "Unit.celsius"}
  def pid_to_name(@mode_01, "40"), do: {"PIDS_C", "Supported PIDs [41-60]", "bitarray"}
  def pid_to_name(@mode_01, "41"), do: {"STATUS_DRIVE_CYCLE", "Monitor status this drive cycle", "special"}
  def pid_to_name(@mode_01, "42"), do: {"CONTROL_MODULE_VOLTAGE", "Control module voltage", "Unit.volt"}
  def pid_to_name(@mode_01, "43"), do: {"ABSOLUTE_LOAD", "Absolute load value", "Unit.percent"}
  def pid_to_name(@mode_01, "44"), do: {"COMMANDED_EQUIV_RATIO", "Commanded equivalence ratio", "Unit.ratio"}
  def pid_to_name(@mode_01, "45"), do: {"RELATIVE_THROTTLE_POS", "Relative throttle position", "Unit.percent"}
  def pid_to_name(@mode_01, "46"), do: {"AMBIANT_AIR_TEMP", "Ambient air temperature", "Unit.celsius"}
  def pid_to_name(@mode_01, "47"), do: {"THROTTLE_POS_B", "Absolute throttle position B", "Unit.percent"}
  def pid_to_name(@mode_01, "48"), do: {"THROTTLE_POS_C", "Absolute throttle position C", "Unit.percent"}
  def pid_to_name(@mode_01, "49"), do: {"ACCELERATOR_POS_D", "Accelerator pedal position D", "Unit.percent"}
  def pid_to_name(@mode_01, "4A"), do: {"ACCELERATOR_POS_E", "Accelerator pedal position E", "Unit.percent"}
  def pid_to_name(@mode_01, "4B"), do: {"ACCELERATOR_POS_F", "Accelerator pedal position F", "Unit.percent"}
  def pid_to_name(@mode_01, "4C"), do: {"THROTTLE_ACTUATOR", "Commanded throttle actuator", "Unit.percent"}
  def pid_to_name(@mode_01, "4D"), do: {"RUN_TIME_MIL", "Time run with MIL on", "Unit.minute"}
  def pid_to_name(@mode_01, "4E"), do: {"TIME_SINCE_DTC_CLEARED", "Time since trouble codes cleared", "Unit.minute"}
  def pid_to_name(@mode_01, "4F"), do: {"unsupported", "unsupported", "unsupported"}
  def pid_to_name(@mode_01, "50"), do: {"MAX_MAF", "Maximum value for mass air flow sensor", "Unit.grams_per_second"}
  def pid_to_name(@mode_01, "51"), do: {"FUEL_TYPE", "Fuel Type", "string"}
  def pid_to_name(@mode_01, "52"), do: {"ETHANOL_PERCENT", "Ethanol Fuel Percent", "Unit.percent"}
  def pid_to_name(@mode_01, "53"), do: {"EVAP_VAPOR_PRESSURE_ABS", "Absolute Evap system Vapor Pressure", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "54"), do: {"EVAP_VAPOR_PRESSURE_ALT", "Evap system vapor pressure", "Unit.pascal"}
  def pid_to_name(@mode_01, "55"), do: {"SHORT_O2_TRIM_B1", "Short term secondary O2 trim - Bank 1", "Unit.percent"}
  def pid_to_name(@mode_01, "56"), do: {"LONG_O2_TRIM_B1", "Long term secondary O2 trim - Bank 1", "Unit.percent"}
  def pid_to_name(@mode_01, "57"), do: {"SHORT_O2_TRIM_B2", "Short term secondary O2 trim - Bank 2", "Unit.percent"}
  def pid_to_name(@mode_01, "58"), do: {"LONG_O2_TRIM_B2", "Long term secondary O2 trim - Bank 2", "Unit.percent"}
  def pid_to_name(@mode_01, "59"), do: {"FUEL_RAIL_PRESSURE_ABS", "Fuel rail pressure (absolute)", "Unit.kilopascal"}
  def pid_to_name(@mode_01, "5A"), do: {"RELATIVE_ACCEL_POS", "Relative accelerator pedal position", "Unit.percent"}
  def pid_to_name(@mode_01, "5B"), do: {"HYBRID_BATTERY_REMAINING", "Hybrid battery pack remaining life", "Unit.percent"}
  def pid_to_name(@mode_01, "5C"), do: {"OIL_TEMP", "Engine oil temperature", "Unit.celsius"}
  def pid_to_name(@mode_01, "5D"), do: {"FUEL_INJECT_TIMING", "Fuel injection timing", "Unit.degree"}
  def pid_to_name(@mode_01, "5E"), do: {"FUEL_RATE", "Engine fuel rate", "Unit.liters_per_hour"}
  def pid_to_name(@mode_01, "5F"), do: {"unsupported", "unsupported", "unsupported"}
  def pid_to_name(@mode_01, _), do: :not_implemented

end
