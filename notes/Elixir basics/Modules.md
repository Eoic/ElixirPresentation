A collection of functions, like a namespace. Every Elixir function must be defined inside a module (because each module is compiled individually, as a separate file of BEAM bytecode?).
```
defmodule Geometry do
	def rectangle_area(a, b) do
		a * b
	end

	def square_area(a), do: rectangle_area(a, a)
end

Geometry.rectangle(6, 3)
```

```
defmodule Geometry do
	def area(a), do: area(a, a)

	def area(a, b), do: a * b
end
```

Module attributes exist only in compilation, and their values are inlined. Some attributes, like `@doc` and `@moduledoc` are registered and included in the binary. Lacks static type system.
```
defmodule Circle do
	@pi 3.141592653
	@moduledoc "Implements basic circle functions."

	@doc "Computes the area of a circle"
	@spec area(number) :: number
	def area(r), do: r * r * @pi

	@doc "Computes the circumference of a circle"
	@spec circumference(number) :: number
	def circumference(r), do: 2 * r * @pi
end
```

View docs:
```
iex(1)> Code.fetch_docs(Circle)
{:docs_v1, 2, :elixir, "text/markdown",
	%{"en" => "Implements basic circle functions"}, %{},
	[
		{{:function, :area, 1}, 5, ["area(r)"],
			%{"en" => "Computes the area of a circle"}, %{}},
		{{:function, :circumference, 1}, 8, ["circumference(r)"],
			%{"en" => "Computes the circumference of a circle"}, %{}}
	]}
```
Can also generate HTML documentation with `ex_doc`.