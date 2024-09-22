defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(Todo.Server, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    path = "#{File.cwd!()}/todos.csv"
    {:ok, Todo.List.CsvImporter.import_entries(path)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  @impl GenServer
  def handle_cast({:update_entry, id, updater_fn}, todo_list) do
    {:noreply, Todo.List.update_entry(todo_list, id, updater_fn)}
  end

  @impl GenServer
  def handle_cast({:delete_entry, id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, id)}
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  def add_entry(new_entry) do
    GenServer.cast(__MODULE__, {:add_entry, new_entry})
  end

  def update_entry(id, updater_fn) do
    GenServer.cast(__MODULE__, {:update_entry, id, updater_fn})
  end

  def delete_entry(id) do
    GenServer.cast(__MODULE__, {:delete_entry, id})
  end
end
