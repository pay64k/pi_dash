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

  # defp child_spec(%{obd_pid_name: obd_pid_name, interval: interval}) do
  #   %{
  #     id: obd_pid_name,
  #     start: {Obd.PidWorker, :start_link, [obd_pid_name, interval]}
  #   }
  # end
end
