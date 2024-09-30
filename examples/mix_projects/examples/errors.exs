defmodule Main do
  def run do
    try_helper = fn fun ->
      try do
        fun.()
        IO.puts("No error.")
      catch
        type, value ->
          IO.puts("""
          [Error]
          Type: #{inspect(type)}
          Value: #{inspect(value)}
          """)
      end
    end

    try_helper.(fn -> raise("Raised an error.") end)
    try_helper.(fn -> throw("Thrown an error.") end)
    try_helper.(fn -> exit("Exited.") end)
  end
end

Main.run()
