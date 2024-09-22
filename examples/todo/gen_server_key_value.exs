defmodule KeyValueStore do
  use GenServer

  def start, do: GenServer.start(KeyValueStore, nil, name: __MODULE__)

  @impl GenServer
  def init(_) do
    :timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_info(:cleanup, state) do
    IO.puts("Performing cleanup...")
    {:noreply, state}
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end
end

defmodule Main do
  def run() do
    {:ok, _} = KeyValueStore.start()
    KeyValueStore.put(:some_key, :some_value) |> IO.inspect()
    KeyValueStore.get(:some_key) |> IO.inspect()
  end
end

Main.run()
