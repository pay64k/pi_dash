defmodule Obd.PidSup do
  use Supervisor

  require Logger

  @relaxation_period 3000

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

  def nudge_workers(elm_pid) do
    final_time =
      __MODULE__
      |> Supervisor.which_children()
      |> Enum.reduce(@relaxation_period, fn {_, pid, _, _}, time_acc ->
        Process.send_after(pid, :write, time_acc)
        time_acc + 1000
      end)

    Process.send_after(elm_pid, :done_nudging, final_time)
  end

  def start_pid_worker(obd_pid_name, interval \\ 1000) do
    extra_logging = Application.fetch_env!(:pi_dash, :extra_logging)
    Supervisor.start_child(__MODULE__, child_spec(obd_pid_name, interval, extra_logging))
  end

  def stop_pid_worker(obd_pid_name) do
    Logger.info("Stop pid_worker: #{obd_pid_name}")
    :ok = Supervisor.terminate_child(__MODULE__, obd_pid_name)
    :ok = Supervisor.delete_child(__MODULE__, obd_pid_name)
  end

  def stop_all_workers() do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.each(fn {id, _, _, _} -> stop_pid_worker(id) end)
  end

  defp child_spec(obd_pid_name, interval, extra_logging) do
    %{
      id: obd_pid_name,
      start: {Obd.PidWorker, :start_link, [obd_pid_name, extra_logging, interval]}
    }
  end
end
