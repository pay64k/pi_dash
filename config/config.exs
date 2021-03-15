use Mix.Config

config :pi_dash,
  serial_port: "/dev/ttys001",
  supported_manufacturers: ["Prolific"],
  supported_serial_names: ["OBDII"],
  app_supported_pids: [
    %{hex: "04", obd_pid_name: :engine_load, min_value: 0, max_value: 100},
    %{hex: "05", obd_pid_name: :coolant_temp, min_value: -40, max_value: 215},
    %{hex: "0C", obd_pid_name: :speed, min_value: 0, max_value: 255},
    %{hex: "0D", obd_pid_name: :rpm, min_value: 0, max_value: 6500, },
    %{hex: "0F", obd_pid_name: :intake_temp, min_value: -40, max_value: 215},
    %{hex: "11", obd_pid_name: :throttle_pos, min_value: 0, max_value: 100},
    %{hex: "0E", obd_pid_name: :timing_advance, min_value: -64, max_value: 63.5}
  ]

# Configures the endpoint
config :pi_dash, PiDashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wyERIrK0CWFw3FSzD3yGrueJzncYo2mH4bSk3jdsXtjHwkLU39O+KLBnCr7G6Awv",
  render_errors: [view: PiDashWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PiDash.PubSub,
  live_view: [signing_salt: "ihWZCbpv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  # level: :info,
  level: :debug,
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :logger,
  metadata: :all,
  backends: [:console, {Loggix, :logger_file_backend}]

config :logger, :logger_file_backend,
  path: "./pi_dash.log",
  # level: :info,
  level: :debug,
  rotate: %{max_bytes: 1_048_576, keep: 5},
  format: "\n$date $time [$level] $metadata $message",
  metadata: [:pid, :module, :function, :line]

import_config "#{Mix.env()}.exs"
