defmodule KeyValueStore do
  use GenServer

  @impl GenServer
  def init(_), do: {:ok, %{}}

  @impl GenServer
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}

  @impl GenServer
  def handle_call({:get, key}, _, state), do: {:reply, Map.get(state, key), state}

  def start(), do: GenServer.start(__MODULE__, nil)

  def get(pid, key), do: GenServer.call(pid, {:get, key})

  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})
end

{:ok, pid} = KeyValueStore.start()
KeyValueStore.put(pid, :apples, 10)
KeyValueStore.get(pid, :apples)
