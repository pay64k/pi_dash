use Mix.Config

# config :pi_dash, PiDashWeb.Endpoint,
#   url: [host: "example.com", port: 80],
#   cache_static_manifest: "priv/static/cache_manifest.json"

config :logger,
  level: :info,
  backends: [{Loggix, :logger_file_backend}]

import_config "prod.secret.exs"
