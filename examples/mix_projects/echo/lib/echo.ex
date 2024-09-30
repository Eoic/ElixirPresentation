defmodule Echo do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  def init(_), do: {:ok, nil}

  def call(id, request) do
    GenServer.call(via_tuple(id), request)
  end

  def via_tuple(id) do
    {:via, Registry, {:registry, {__MODULE__, id}}}
  end

  def handle_call(request, _, state) do
    {:reply, %{request | type: "Echo"}, state}
  end
end

Registry.start_link(name: :registry, keys: :unique)
Echo.start_link(1)
Echo.start_link(2)
Echo.start_link(3)
Echo.call(1, %{:message => "Hello", :type => "Forward"}) |> IO.inspect()
Echo.call(2, %{:message => "There", :type => "Forward"}) |> IO.inspect()
Echo.call(3, %{:message => "Again", :type => "Forward"}) |> IO.inspect()
