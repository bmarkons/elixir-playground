defmodule Balancero do
  @moduledoc false
  require Logger
  use GenericServer

  def start, do: start(workers: [])

  def scale_up(balancero, n) do
    balancero
    |> call({:scale_up, n})
  end

  def scale_down(balancero, n) do
    balancero
    |> call({:scale_down, n})
  end

  def inspect(balancero) do
    balancero
    |> call(:inspect)
  end

  def schedule(balancero, work) do
    balancero
    |> cast({:schedule, work})
  end

  def handle_call(state, {:scale_up, n}) do
    {"#{n} new workers created", [workers: state[:workers] ++ create_workers(n)]}
  end

  def handle_call(state, {:scale_down, n}) do
    {"#{n} workers terminated", [workers: terminate_workers(n, state[:workers])]}
  end

  def handle_call(state, :inspect) do
    response = %{
      workers_count: Enum.count(state[:workers]),
      pids: inspect(state[:workers], limit: :infinity)
    }

    {response, state}
  end

  def handle_cast(state, {:schedule, work}) do
    state[:workers]
    |> Enum.random()
    |> Worker.schedule(work)

    state
  end

  defp create_workers(n) do
    for _ <- 1..n, do: Worker.start() |> elem(1)
  end

  def terminate_workers(0, workers), do: workers
  def terminate_workers(_n, []), do: []

  def terminate_workers(n, [pid | workers]) do
    Process.exit(pid, :kill)
    terminate_workers(n - 1, workers)
  end
end
