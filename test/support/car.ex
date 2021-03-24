defmodule Car do
  use GenServer

  def start_link(elm_pid) do
    GenServer.start(__MODULE__, [elm_pid], name: __MODULE__)
  end

  def init([elm_pid]) do
    {:ok, %{elm_pid: elm_pid, pids: []}}
  end

  def start_sending(pid, interval \\ 1000) do
    GenServer.cast(__MODULE__, {:start_sending, pid, interval})
  end

  def stop_sending(pid) do
    GenServer.cast(__MODULE__, {:stop_sending, pid})
  end

  def handle_cast({:stop_sending, pid}, state) do
    p = Enum.filter(state.pids, fn %{pid: p} -> p == pid end) |> List.first()
    :timer.cancel(p.tref)
    {:noreply, state}
  end

  def handle_cast({:start_sending, pid, interval}, state = %{elm_pid: elm_pid, pids: pids}) do
    data = "486B1041"<> Obd.PidTranslator.name_to_pid(pid) <>"0F3251"
    to_send = {:circuits_uart, "port", data}
    {:ok, tref} = :timer.send_interval(interval, elm_pid, to_send)
    {:noreply, %{state | pids: pids ++ [%{pid: pid, tref: tref}] }}
  end
end
