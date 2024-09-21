A runtime decision about which code to execute, based on the nature of the input data. In Elixir, this can be achieved with *protocols*.

Making integer printable through `String.Chars` protocol implementation:
```
defimpl String.Chars, for: Integer do
	def to_string(term) do
		Integer.to_string(term)
	end
end
```