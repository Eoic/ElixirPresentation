defmodule KvServer do
  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:result, value} ->
        value
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  @spec start(any()) :: pid()
  def start(callback_module) do
    spawn(fn ->
      state = callback_module.init()
      loop(state, callback_module)
    end)
  end

  def loop(state, callback_module) do
    new_state = receive do
      {:call, request, caller_pid} ->
        {result, new_state} = callback_module.handle_call(request, state)
        send(caller_pid, {:result, result})
        new_state

      {:cast, request} ->
        callback_module.handle_cast(request, state)
    end

    loop(new_state, callback_module)
  end
end
