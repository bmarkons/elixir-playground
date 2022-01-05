defmodule ServerProcess do
  def create(n) do
    for _i <- 1..n, do: create()
  end

  def create do
    spawn(fn -> serve() end)
  end

  defp serve do
    receive do
      {:send, sender_pid, send_to_pid, message} ->
        IO.puts("[#{inspect(self())}] Received send instruction from #{inspect(sender_pid)}.")

        IO.puts(
          "[#{inspect(self())}] Sending messsage (#{message}) to #{inspect(send_to_pid)}..."
        )

        send(send_to_pid, {:print, self(), message})
        IO.puts("[#{inspect(self())}] Sent.")

      {:print, sender_pid, message} ->
        IO.puts("[#{inspect(self())}] Received print instruction from #{inspect(sender_pid)}:")
        IO.puts("[#{inspect(self())}] #{message}")
    end

    serve()
  end
end
