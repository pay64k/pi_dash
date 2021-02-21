import Config

config :pi_dash,
  serial_port: System.fetch_env!("SERIAL_PORT")
