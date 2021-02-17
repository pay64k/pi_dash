# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

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
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :logger,
  metadata: :all,
  backends: [:console, {LoggerFileBackend, :logger_file_backend}]

config :logger, :logger_file_backend,
  path: "./pi_dash.log",
  level: :debug,
  format: "\n$date $time [$level] $metadata $message",
  metadata: [:pid, :module, :function, :line]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
