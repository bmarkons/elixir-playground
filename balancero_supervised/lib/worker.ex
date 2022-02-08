defmodule Worker do
  @moduledoc false
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def handle_cast({:work, fun}, state) do
    fun.()

    {:noreply, state}
  end

  def schedule(worker, work) do
    worker
    |> GenServer.cast({:work, work})
  end
end
