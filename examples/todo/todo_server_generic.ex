defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} =
          callback_module.handle_call(
            request,
            current_state
          )

        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )

        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end
end

defmodule TodoServer do
  def init() do
    path = "#{File.cwd!()}/todos.csv"
    TodoList.CsvImporter.import_entries(path)
  end

  def start() do
    ServerProcess.start(TodoServer)
  end

  def add_entry(server_pid, new_entry) do
    ServerProcess.call(server_pid, {:add_entry, new_entry})
  end

  def update_entry(server_pid, id, updater_fn) do
    ServerProcess.cast(server_pid, {:update_entry, id, updater_fn})
  end

  def delete_entry(server_pid, id) do
    ServerProcess.cast(server_pid, {:delete_entry, id})
  end

  def entries(server_pid, date) do
    ServerProcess.call(server_pid, {:entries, date})
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_cast({:update_entry, id, updater_fn}, todo_list) do
    TodoList.update_entry(todo_list, id, updater_fn)
  end

  def handle_cast({:delete_entry, id}, todo_list) do
    TodoList.delete_entry(todo_list, id)
  end
end

defimpl String.Chars, for: TodoList do
  def to_string(_) do
    "#TodoList"
  end
end

defimpl Collectable, for: TodoList do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list

  defp into_callback(_, :halt), do: :ok
end

defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def new(entries), do: Enum.into(entries, new())

  def entries(todo_list, date) do
    todo_list.entries
    |> Map.values()
    |> Enum.filter(fn entry -> entry.date === date end)
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.next_id,
        entry
      )

    %TodoList{todo_list | entries: new_entries, next_id: todo_list.next_id + 1}
  end

  def update_entry(todo_list, id, updater_fn) do
    case Map.fetch(todo_list.entries, id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fn.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, id) do
    new_entries = Map.delete(todo_list.entries, id)
    %TodoList{todo_list | entries: new_entries}
  end
end

defmodule TodoList.CsvImporter do
  def import_entries(path) do
    path
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim("\n")
      |> String.split(",")
      |> (fn [date, title] -> %{title: title, date: Date.from_iso8601!(date)} end).()
    end)
    |> Enum.to_list()
    |> TodoList.new()
  end
end

defmodule Main do
  def run() do
    server = TodoServer.start()
    IO.inspect(TodoServer.entries(server, ~D[2023-12-19]))
    TodoServer.delete_entry(server, 1)
    IO.inspect(TodoServer.entries(server, ~D[2023-12-19]))
  end
end

Main.run()
