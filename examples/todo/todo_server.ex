defmodule TodoServer do
  def start do
    spawn(fn -> loop(TodoList.new()) end)
  end

  def start(path) do
    todo_list = TodoList.CsvImporter.import_entries(path)
    spawn(fn -> loop(todo_list) end)
  end

  def add_entry(todo_sever, new_entry) do
    send(todo_sever, {:add_entry, new_entry})
  end

  def update_entry(todo_server, id, updater_fn) do
    send(todo_server, {:update_entry, id, updater_fn})
  end

  def delete_entry(todo_sever, id) do
    send(todo_sever, {:delete_entry, id})
  end

  def entries(todo_server, date) do
    send(todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message -> process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:entries, caller_pid, date}) do
    entries = TodoList.entries(todo_list, date)
    send(caller_pid, {:todo_entries, entries})
    todo_list
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:update_entry, id, updater_fn}) do
    TodoList.update_entry(todo_list, id, updater_fn)
  end

  defp process_message(todo_list, {:delete_entry, id}) do
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

path = "#{File.cwd!()}/todos.csv"
server = TodoServer.start(path)

IO.inspect(TodoServer.entries(server, ~D[2023-12-19]))
TodoServer.delete_entry(server, 1)
IO.inspect(TodoServer.entries(server, ~D[2023-12-19]))
