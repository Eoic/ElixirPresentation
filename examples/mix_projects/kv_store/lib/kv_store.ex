defmodule KvStore do
  use Application

  def init(), do: Map.new()

  def start() do
    KvServer.start(__MODULE__)
  end

  def get(pid, key) do
    KvServer.call(pid, {:get, key})
  end

  def put(pid, key, value) do
    KvServer.cast(pid, {:put, key, value})
  end

  def drop(pid, key) do
    KvServer.cast(pid, {:drop, key})
  end

  def size(pid) do
    KvServer.call(pid, {:size})
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end

  def handle_call({:size}, state) do
    {map_size(state), state}
  end

  def handle_call(_, state) do
    {nil, state}
  end

  def handle_cast({:put, key, value}, state) do
    Map.put(state, key, value)
  end

  def handle_cast({:drop, key}, state) do
    Map.delete(state, key)
  end

  def handle_cast(_, state) do
    state
  end

  def start(_, _) do
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
