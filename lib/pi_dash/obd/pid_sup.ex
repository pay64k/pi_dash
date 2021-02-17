defmodule Obd.PidSup do
  use Supervisor

  def start_link(obd_pids \\ []) do
    Supervisor.start_link(__MODULE__, obd_pids, name: __MODULE__)
  end

  @impl true
  def init(obd_pids) do
    children = Enum.map(obd_pids, &child_spec/1)

    opts = [
      strategy: :one_for_one,
      max_restarts: 5_000,
      max_seconds: 1
    ]
    Supervisor.init(children, opts)
  end

  def children() do
    Supervisor.which_children(__MODULE__)
  end

  defp child_spec(%{obd_pid: obd_pid, interval: interval}) do
    %{
      id: String.to_atom(obd_pid),
      start: {Obd.PidWorker, :start_link, [obd_pid, interval]}
    }
  end

end
