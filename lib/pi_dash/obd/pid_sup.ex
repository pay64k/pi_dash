defmodule Obd.PidSup do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    opts = [
      strategy: :one_for_one,
      max_restarts: 5_000,
      max_seconds: 1
    ]

    Supervisor.init([], opts)
  end

  def start_pid_worker(obd_pid_name, interval \\ 1000) do
    Supervisor.start_child(__MODULE__, child_spec(obd_pid_name, interval))
  end

  def stop_pid_worker(obd_pid_name) do
    Supervisor.delete_child(__MODULE__, obd_pid_name)
  end
  # TODO kill pid_worker

  defp child_spec(obd_pid_name, interval) do
    %{
      id: obd_pid_name,
      start: {Obd.PidWorker, :start_link, [obd_pid_name, interval]}
    }
  end
end
