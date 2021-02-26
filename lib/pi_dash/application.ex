defmodule PiDash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    Logger.info("Starting application #{__MODULE__}")
    children = [
      # Start the Telemetry supervisor
      PiDashWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PiDash.PubSub},
      # Start the Endpoint (http/https)
      PiDashWeb.Endpoint,
      # Start a worker by calling: PiDash.Worker.start_link(arg)
      # {PiDash.Worker, arg}
      %{
        id: Elm.Connector,
        start: {Elm.Connector, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_one, name: PiDash.Supervisor, max_restarts: 0]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PiDashWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # TODO: read all setting from property file, in env.sh point to location of the file
  def pids_to_monitor() do
    [{"RPM", 350}, {"SPEED", 1000}]
    |> Enum.map(fn {pid, interval} -> %{obd_pid: pid, interval: interval} end)
  end
end
