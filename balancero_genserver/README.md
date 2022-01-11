# Balancero Generic Server

```ex
# Start Balancero process
{:ok, b} = Balancero.start()

# Inspect Balancero state
b |> Balancero.inspect()

# Spin up workers
b |> Balancero.scale_up(3)

# Terminate some
b |> Balancero.scale_down(1)

# And finally, schedule actual work on the worker
b |> Balancero.schedule(fn -> IO.puts("Doing actual work from #{inspect(self())}") end)
```
