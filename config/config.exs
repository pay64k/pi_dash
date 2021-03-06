use Mix.Config

config :pi_dash,
  serial_port: "/dev/ttys000",
  app_supported_pids: [
    %{obd_pid_name: :rpm, max_value: 6500},
    %{obd_pid_name: :speed, max_value: 255}
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
  level: :info,
  # level: :debug,
  rotate: %{max_bytes: 1048576, keep: 5},
  format: "\n$date $time [$level] $metadata $message",
  metadata: [:pid, :module, :function, :line]

import_config "#{Mix.env()}.exs"
