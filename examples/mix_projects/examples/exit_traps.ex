defmodule Main do
  def run() do
    Process.flag(:trap_exit, true)

    spawn_link(fn ->
      exit("Something went wrong.")
    end)

    receive do
      message ->
        dbg(message)
    end
  end
end

Main.run()
