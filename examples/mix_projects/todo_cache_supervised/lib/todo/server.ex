defmodule Todo.Server do
  use GenServer

  def start(list_name) do
    GenServer.start(Todo.Server, list_name)
  end

  @impl GenServer
  def init(list_name) do
    {:ok, {list_name, nil}, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, {list_name, nil}) do
    todo_list = Todo.Database.get(list_name) || Todo.List.new()
    {:noreply, {list_name, todo_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, todo_list_data = {_list_name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), todo_list_data}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {list_name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}}
  end

  @impl GenServer
  def handle_cast({:update_entry, id, updater_fn}, {list_name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, id, updater_fn)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, new_list}}
  end

  @impl GenServer
  def handle_cast({:delete_entry, id}, {list_name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, id)
    Todo.Database.store(list_name, new_list)
    {:noreply, {list_name, todo_list}}
  end

  def entries(server, date) do
    GenServer.call(server, {:entries, date})
  end

  def add_entry(server, new_entry) do
    GenServer.cast(server, {:add_entry, new_entry})
  end

  def update_entry(server, id, updater_fn) do
    GenServer.cast(server, {:update_entry, id, updater_fn})
  end

  def delete_entry(server, id) do
    GenServer.cast(server, {:delete_entry, id})
  end
end
