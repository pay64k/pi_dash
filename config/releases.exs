import Config

config :pi_dash,
  serial_port: System.fetch_env!("SERIAL_PORT"),
  supported_manufacturers: System.fetch_env!("SUPPORTED_MANUFACTURERS") |> String.split(","),
  supported_serial_names: System.fetch_env!("SUPPORTED_SERIAL_NAMES") |> String.split(",")
