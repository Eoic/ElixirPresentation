Functions differ in name and arity. If you provide multiple definitions of the same function with the same arity, the function has multiple clauses.
```
defmodule Geometry do
	def area({:rectangle, a, b}), do: a * b
	def area({:square, a}), do: a * a
	def area({:circle, r}), do: r * r * :math.pi
	def area(_), do: {:error, {:unknown_shape, nil}}
end

fun = &Geometry.area/1
fun.({:circle, 4})
fun.({:square, 5})
fun.({:rectangle, 4, 5})
```F