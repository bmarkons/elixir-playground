defmodule ProcessHelpers do
  def queue(pid) do
    {pid, [alive?: Process.alive?(pid)], Process.info(pid, :message_queue_len)}
  end

  def queues(pids) do
    for pid <- pids, do: queue(pid)
  end
end
