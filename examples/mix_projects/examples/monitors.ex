defmodule Main do
  def run do
    target_pid =
      spawn(fn ->
        Process.sleep(1000)
      end)

    Process.monitor(target_pid)

    receive do
      message -> dbg(message)
    end
  end
end

Main.run()
