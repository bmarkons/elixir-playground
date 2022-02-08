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
<br>
<p align="center">
  <img src="https://user-images.githubusercontent.com/9396752/148981397-5498291a-df87-44d8-8d18-ca9042046594.png" />
</p>
