use Mix.Config

config :pi_dash, PiDashWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :debug
