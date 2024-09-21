```
defmodule NaturalNumbers do
	def print(1), do: IO.puts(1)

	def print(n) when n > 0 do
		IO.puts(n)
		print(n - 1)
	end
end
```
```
# Simple:
defmodule ListUtils do
	def sum([]), do: 0
	def sum([head | tail]), do: head + sum(tail) # Not a tail call!
end

ListUtils.sum([])        # Returns: 0
ListUtils.sum([1, 2, 3]) # Returns: 6

# Tail-call optimized:
defmodule ListHelper do
	def sum(list) do
		do_sum(0, list)
	end

	defp do_sum(current_sum, []) do
		current_sum
	end

	defp do_sum(current_sum, [head | tail]) do
		new_sum = head + current_sum
		do_sum(new_sum, tail)
	end
end
```

**Tail-call optimization**
When the last thing function does is calling another function or itself. Calling tail function does not result in the usual stack push. No additional stack space is allocated, which means tail call does not consume additional memory.

### Higher-order functions
Takes one or more functions as input or returns one or more functions (or both).
```
Enum.each(
	[1, 2, 3],
	fn x -> IO.puts(x) end
)

Enum.map(
	[1, 2, 3],
	fn x -> x * 2 end
)
```

Streams:
No need to iterate over all elements of the list. Just return the function that does this operation. 
```
employees
	|> Stream.with_index()
	|> Enum.each(fn {employee, index} ->
		IO.puts("#{index + 1}. #{employee}")
	end)

[9, -1, "foo", 25, 49]
	|> Stream.filter(&(is_number(&1) and &1 > 0))
	|> Stream.map(&{&1, :math.sqrt(&1)})
	|> Stream.with_index()
	|> Enum.each(fn {{input, result}, index} -> IO.puts("#{index + 1}. sqrt(#{input}) = #{result}") end)

1. sqrt(9) = 3.0
2. sqrt(25) = 5.0
3. sqrt(49) = 7.0

# Very large file:
def large_lines!(path) do
	path
	|> File.stream!()
	|> Stream.map(&String.trim_trailing(&1, "\n"))
	|> Enum.filter(&(String.length(&1) > 80))
end

# Infinite streams.
numbers = Stream.iterate(1, fn prev -> prev + 1)
Enum.take(numbers, 10)
```