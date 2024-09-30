defmodule EchoTest do
  use ExUnit.Case
  doctest Echo

  test "greets the world" do
    assert Echo.hello() == :world
  end
end
