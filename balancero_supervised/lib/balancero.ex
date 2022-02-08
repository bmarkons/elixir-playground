defmodule Balancero do
  @moduledoc false
  require Logger
  use GenServer

  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def start do
    Supervisor.start_link([__MODULE__], strategy: :one_for_one)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [workers: []], name: :balancero)
  end

  def scale_up(balancero, n) do
    balancero
    |> GenServer.call({:scale_up, n})
  end

  def scale_down(balancero, n) do
    balancero
    |> GenServer.call({:scale_down, n})
  end

  def inspect(balancero) do
    balancero
    |> GenServer.call(:inspect)
  end

  def schedule(balancero, work) do
    balancero
    |> GenServer.cast({:schedule, work})
  end

  def handle_call({:scale_up, n}, _from, state) do
    {:reply, "#{n} new workers created", [workers: state[:workers] ++ create_workers(n)]}
  end

  def handle_call({:scale_down, n}, _from, state) do
    {:reply, "#{n} workers terminated", [workers: terminate_workers(n, state[:workers])]}
  end

  def handle_call(:inspect, _from, state) do
    response = %{
      workers_count: Enum.count(state[:workers]),
      pids: inspect(state[:workers], limit: :infinity)
    }

    {:reply, response, state}
  end

  def handle_cast({:schedule, work}, state) do
    state[:workers]
    |> Enum.random()
    |> child_pid()
    |> Worker.schedule(work)

    {:noreply, state}
  end

  defp create_workers(n) do
    for _ <- 1..n do
      Supervisor.start_link([Worker], strategy: :one_for_one, max_restarts: 1_000_000)
      |> elem(1)
    end
  end

  def terminate_workers(0, workers), do: workers
  def terminate_workers(_n, []), do: []

  def terminate_workers(n, [pid | workers]) do
    Process.exit(pid, :kill)
    terminate_workers(n - 1, workers)
  end

  defp child_pid(supervisor) do
    supervisor
    |> Supervisor.which_children()
    |> hd()
    |> elem(1)
  end
end
