defmodule Todo.Database do
  use GenServer
  alias Todo.DatabaseWorker

  @db_folder "./persist"

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    workers =
      0..2
      |> Enum.reduce(%{}, fn index, workers ->
        {:ok, pid} = DatabaseWorker.start(@db_folder)
        Map.put(workers, index, pid)
      end)

    {:ok, workers}
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get(key) do
    key
    |> choose_worker()
    |> DatabaseWorker.get(key)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> DatabaseWorker.store(key, data)
  end

  @impl GenServer
  def handle_call({:worker, list_name}, _, workers) do
    index = :erlang.phash2(list_name, 3)
    {:reply, Map.get(workers, index), workers}
  end

  defp choose_worker(list_name) do
    GenServer.call(__MODULE__, {:worker, list_name})
  end
end
