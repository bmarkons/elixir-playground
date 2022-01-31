defmodule Worker do
  @moduledoc false
  require Logger
  use GenericServer

  def start, do: start(nil)

  def handle_call(state, message) do
    {"Not implemented", nil}
  end

  def handle_cast(state, {:work, fun}) do
    fun.()

    nil
  end

  def schedule(worker, work) do
    worker
    |> cast({:work, work})
  end
end
