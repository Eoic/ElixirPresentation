# 1. "iex --sname node1@desktop --cookie indeform"
# 2. "iex --sname node2@desktop --cookie indeform cross_comms.exs"
# 3. On "node1", connect to "node2" and send a message:
#     Node.connect(:"node2@desktop")
#     Node.list()
#     send({:messenger, :"node2@desktop"}, "Hello there.")

defmodule Messenger do
  def read() do
    receive do
      message -> IO.inspect(message)
    end

    read()
  end
end

pid = spawn(Messenger, :read, [])
Process.register(pid, :messenger)
