defmodule Todo.CacheTest do
  use ExUnit.Case

  setup %{} do
    File.rm_rf("persist")
    :ok
  end

  # test "server_process" do
  #   {:ok, cache} = Todo.Cache.start()
  #   bob_pid = Todo.Cache.server_process(cache, "bob")
  #   assert bob_pid == Todo.Cache.server_process(cache, "bob")
  #   assert bob_pid != Todo.Cache.server_process(cache, "alice")
  # end

  # test "todo operations" do
  #   {:ok, cache} = Todo.Cache.start()
  #   alice = Todo.Cache.server_process(cache, "alice")
  #   Todo.Server.add_entry(alice, %{date: ~D[2023-12-19], title: "Dentist"})
  #   entries = Todo.Server.entries(alice, ~D[2023-12-19])
  #   assert [%{date: ~D[2023-12-19], title: "Dentist"}] = entries
  # end

  # test "todo database servers" do
  #   {:ok, cache} = Todo.Cache.start()
  #   alice_server = Todo.Cache.server_process(cache, "alice")
  #   john_server = Todo.Cache.server_process(cache, "john")
  #   bob_server = Todo.Cache.server_process(cache, "bob")

  #   assert alice_server !== john_server
  #   assert alice_server !== bob_server
  #   assert john_server !== bob_server
  # end

  test "todo database workers" do
    {:ok, cache} = Todo.Cache.start()
    alice_server = Todo.Cache.server_process(cache, "alice")
    john_server = Todo.Cache.server_process(cache, "john")

    alice_entry = %{date: ~D[2023-12-19], title: "Dentist"}
    john_entry = %{date: ~D[2023-12-19], title: "Studying"}
    Todo.Server.add_entry(alice_server, alice_entry)
    Todo.Server.add_entry(john_server, john_entry)

    alice_entries = Todo.Server.entries(alice_server, ~D[2023-12-19])
    assert [%{date: ~D[2023-12-19], title: "Dentist"}] = alice_entries

    john_entries = Todo.Server.entries(john_server, ~D[2023-12-19])
    assert [%{date: ~D[2023-12-19], title: "Studying"}] = john_entries
  end
end
