use Mix.Config

# config :pi_dash, PiDashWeb.Endpoint,
#   url: [host: "example.com", port: 80],
#   cache_static_manifest: "priv/static/cache_manifest.json"

config :logger,
  level: System.get_env("LOG_LEVEL", "info") |> String.to_atom,
  backends: [{Loggix, :logger_file_backend}]

config :logger, :logger_file_backend,
  path: "/home/#{System.get_env("USER")}/pi_dash/log/pi_dash.log"

import_config "prod.secret.exs"
