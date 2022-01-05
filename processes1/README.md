# Create 10 processes which receive and send messages

Spin up IEx and run the following commands:

```
# Load elixir files
c "script.exs"
c "process_helpers.exs"
import ProcessHelpers

# Create 10 identical processes
pids = ServerProcess.create(10)

# To print information on process queues
queues pids

# Instruct process 1 to print message Hello World
send(Enum.at(pids, 1), {:print, self(), "Hello World"})

# Instruct process 1 to send message to process 2
send(Enum.at(pids, 1), {:send, self(), Enum.at(pids, 2), "Hello World"})
```
