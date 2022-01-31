defmodule GenericServer do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def start(initial_state) do
        pid = spawn(fn -> loop(initial_state, __MODULE__) end)

        {:ok, pid}
      end

      defp loop(state, module) do
        receive do
          {:call, caller, message} ->
            new_state = handle_call(state, message, caller, module)
            loop(new_state, module)

          {:cast, message} ->
            new_state = handle_cast(state, message, module)
            loop(new_state, module)
        end
      end

      def cast(server, message) do
        server
        |> send({:cast, message})

        :ok
      end

      def call(server, message) do
        server
        |> send({:call, self(), message})

        receive do
          {:response, response} ->
            response
        after
          5000 ->
            raise "Connection failed!"
        end
      end

      defp handle_call(state, message, caller, module) do
        {response, new_state} = module.handle_call(state, message)
        send(caller, {:response, response})
        new_state
      end

      defp handle_cast(state, message, module) do
        module.handle_cast(state, message)
      end
    end
  end
end
