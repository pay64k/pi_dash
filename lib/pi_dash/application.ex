defmodule PiDash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

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
      %{
        id: ElmConnectorStatem,
        start: {ElmConnectorStatem, :start_link, [serial_port()]}
      }
      # TODO start pid sup after configuration of elm
      # %{
      #   id: Obd.PidSup,
      #   start: {Obd.PidSup, :start_link, [pids_to_monitor()]}
      # }
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
  defp pids_to_monitor() do
    [{"0C", 350}, {"0D", 1000}]
    |> Enum.map(fn {pid, interval} -> %{obd_pid: pid, interval: interval} end)
  end

  defp serial_port() do
    case find_serial_port() do
      nil -> Application.fetch_env!(:pi_dash, :serial_port)
      {name, _info} -> name
    end
  end

  defp find_serial_port() do
    Circuits.UART.enumerate()
    |> Enum.filter(fn {_, m} ->
      :manufacturer in Map.keys(m) and
        String.contains?(m.manufacturer, "Prolific")
    end)
    |> List.first()
  end
end
