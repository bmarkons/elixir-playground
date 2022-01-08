defmodule Worker do
  require Logger

  def start do
    spawn(&worker/0)
  end

  defp worker do
    receive do
      {:work, fun} -> fun.()
      any -> Logger.error("Unsupported message received.")
    end

    worker()
  end
end
