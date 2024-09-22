defmodule Counter do
  def start(), do: spawn(&loop/0)

  def loop(current_state \\ 0) do
    new_state = receive do
      {:result, caller_pid} ->
        send(caller_pid, {:response, current_state})
        current_state

      :increment -> current_state + 1
      :decrement -> current_state - 1
    end

    loop(new_state)
  end
end

defmodule Main do
  def run() do
    server_pid = Counter.start()
    send(server_pid, :increment)
    send(server_pid, :increment)
    send(server_pid, :decrement)
    send(server_pid, {:result, self()})

    # Prints: 1
    receive do
      {:response, result} -> IO.puts(result)
      _ -> IO.puts("Unknown message.")
    end
  end
end

Main.run()
