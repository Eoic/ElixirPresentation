defmodule KvStoreTest do
  use ExUnit.Case
  doctest KvStore

  test "start a server process" do
    assert is_pid(KvStore.start())
  end

  test "can store values" do
    pid = KvStore.start()
    KvStore.put(pid, :apples, 10)
    KvStore.put(pid, :bananas, 2)
    KvStore.put(pid, :strawberries, 15)
    assert KvStore.get(pid, :apples) == 10
    assert KvStore.get(pid, :bananas) == 2
    assert KvStore.get(pid, :strawberries) == 15
    assert KvStore.get(pid, :blueberries) == nil
  end

  test "can drop values" do
    pid = KvStore.start()
    KvStore.put(pid, :apples, 10)
    assert KvStore.get(pid, :apples) == 10
    KvStore.drop(pid, :apples)
    assert KvStore.get(pid, :apples) == nil
  end

  test "can acquire store size" do
    pid = KvStore.start()
    assert KvStore.size(pid) === 0
    KvStore.put(pid, :apples, 10)
    assert KvStore.size(pid) === 1
    KvStore.put(pid, :bananas, 2)
    KvStore.put(pid, :strawberries, 15)
    assert KvStore.size(pid) === 3
  end
end
