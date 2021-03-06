defmodule Obd.PidSup do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    # children = Enum.map(obd_pids, &child_spec/1)
    children = []

    opts = [
      strategy: :one_for_one,
      max_restarts: 5_000,
      max_seconds: 1
    ]

    Supervisor.init(children, opts)
  end

  def start_pid_worker(obd_pid_name, interval \\ 1000) do
    Supervisor.start_child(__MODULE__, child_spec(obd_pid_name, interval))
  end

  defp child_spec(obd_pid_name, interval) do
    pid = String.to_atom(obd_pid_name)
    %{
      id: pid,
      start: {Obd.PidWorker, :start_link, [pid, interval]}
    }
  end
end
