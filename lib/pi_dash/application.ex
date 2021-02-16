defmodule PiDash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PiDashWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PiDash.PubSub},
      # Start the Endpoint (http/https)
      PiDashWeb.Endpoint,
      # Start a worker by calling: PiDash.Worker.start_link(arg)
      # {PiDash.Worker, arg}
      {Circuits.UART, name: Circuits.UART},
      %{
        id: UartConnector,
        start: {UartConnector, :start_link, ["/dev/pts/2"]}
      },
      %{
        id: Obd.PidSup,
        start: {Obd.PidSup, :start_link, [["0C", "0D"]]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_one, name: PiDash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PiDashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
