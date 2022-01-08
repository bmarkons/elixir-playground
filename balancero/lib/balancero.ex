defmodule Balancero do
  require Logger

  def start do
    Logger.info("Starting Balancero...")
    pid = spawn(fn -> balancero([]) end)
    Logger.info("Balancero started!")
    pid
  end

  defp balancero(workers) do
    receive do
      {:scale_up, n} ->
        balancero(workers ++ create_workers(n))

      {:scale_down, n} ->
        Logger.info("Balancero terminating #{n} workers...")
        balancero(terminate_workers(n, workers))

      {:schedule, work} ->
        pid = Enum.random(workers)
        send(pid, work)
        balancero(workers)

      :inspect ->
        Logger.info("Balancero has #{Enum.count(workers)} workers ready.")
        Logger.info("PIDs: #{inspect(workers, limit: :infinity)}")
        balancero(workers)
    end
  end

  defp create_workers(n) do
    pids = for _ <- 1..n, do: Worker.start()
    Logger.info("Balancero created #{n} new workers.")
    pids
  end

  def terminate_workers(0, workers), do: workers
  def terminate_workers(n, []), do: []

  def terminate_workers(n, [pid | workers]) do
    Process.exit(pid, :kill)
    terminate_workers(n - 1, workers)
  end
end
