defimpl String.Chars, for: Todo.List do
  def to_string(_) do
    "#Todo.List"
  end
end

defimpl Collectable, for: Todo.List do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    Todo.List.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list

  defp into_callback(_, :halt), do: :ok
end

defmodule Todo.List do
  defstruct next_id: 1, entries: %{}

  def new(), do: %Todo.List{}

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

    %Todo.List{todo_list | entries: new_entries, next_id: todo_list.next_id + 1}
  end

  def update_entry(todo_list, id, updater_fn) do
    case Map.fetch(todo_list.entries, id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fn.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, id) do
    new_entries = Map.delete(todo_list.entries, id)
    %Todo.List{todo_list | entries: new_entries}
  end
end

defmodule Todo.List.CsvImporter do
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
    |> Todo.List.new()
  end
end
