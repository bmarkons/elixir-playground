defmodule Worker do
  require Logger

  def start do
    GenericServer.start(__MODULE__, nil)
  end

  def handle_call(state, message) do
    {"Not implemented", nil}
  end

  def handle_cast(state, {:work, fun}) do
    fun.()

    nil
  end

  def schedule(worker, work) do
    worker
    |> GenericServer.cast({:work, work})
  end
end
