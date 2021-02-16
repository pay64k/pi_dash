defmodule PidWorker do
  use GenServer

  def start_link(obd_pid) do
    name = String.to_atom(obd_pid)
    {int_obd_pid, _} = Integer.parse(obd_pid, 16)
    GenServer.start(__MODULE__, [int_obd_pid, obd_pid],  name: name)
  end

  def init([int_obd_pid, obd_pid]) do
    tref = Process.send_after(self(), :write, 1000)
    {:ok, %{int_obd_pid: int_obd_pid, obd_pid: obd_pid, tref: tref}}
  end

  def handle_info(:write, state = %{obd_pid: obd_pid, tref: tref}) do
    Process.cancel_timer(tref)
    IO.puts("sending #{obd_pid}")
    UartComm.send("01" <> obd_pid)
    tref = Process.send_after(self(), :write, 1000)
    {:noreply, %{state | tref: tref}}
  end

  def handle_info(%{data: data, pid: int_obd_pid}, state = %{int_obd_pid: int_obd_pid}) do
    IO.puts("obd worker #{int_obd_pid} recieved data: #{inspect data}")
    {:noreply, state}
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end
