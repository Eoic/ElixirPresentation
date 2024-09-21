1. A module is in charge of abstracting some behavior (e.g. String, List, Enum).
2. The module's functions usually expect an instance of the abstraction as the first argument (e.g. `"Hello world"`, `[1, 2, 3]`).''
3. Modifier functions return a modified version of the abstraction (e.g. `[2, 4, 9]`).
4. Query functions return some other type of data.
```
days =
	MapSet.new() |>
	MapSet.put(:monday) |>
	MapSet.put(:tuesday)

MapSet.member?(days, :monday)
```

**Structs**
```
defmodule Fraction do
	struct a: nil, b: nil

	def new(a, b) do
		%Fraction{a: a, b: b}
	end

	def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
		new(
			a1 * b2 + a2 * b1,
			b1 * b2
		)
	end
end

one_half = %Fraction{a: 1, b: 2}
one_quarter = %Fraction{one_half | b: 4}
```