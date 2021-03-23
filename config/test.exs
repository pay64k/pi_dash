use Mix.Config

config :pi_dash, PiDashWeb.Endpoint,
  http: [port: 4002],
  server: false

config :pi_dash,
  connect_timeout: 100

config :logger, level: :debug
