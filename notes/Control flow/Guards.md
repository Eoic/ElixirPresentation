Extension of the basic pattern matching mechanism.
```
defmodule TestNumber do
	def test(x) when is_number(x) and x > 0, do: :positive
	def test(x) when is_number(x) and x < 0, do: :negative
	def test(x) when x == 0, do: :zero
end
```

Anonymous functions
```
test_num =
	fn
		x when is_number(x) and x < 0 -> :negative
		x when x == 0 -> :zero
		x when is_number(x) and x > 0 -> :positive
	end
```

Conditional branching:
```
defmodule Polymorphic do
	def double(x) when is_number(x), do: 2 * x
	def double(x) when is_binary(x), do: x <> x
	def double(_), do: nil
end

Polymorphic.double(3)     # Returns: 6
Polymorphic.double("Jar") # Returns: "JarJar"
```

A multiclause-powered recursion is primarily used for looping.
```
defmodule Factorial do
	def fact(0), do: 1
	def fact(n), do: n * fact(n - 1)
end
```

```
defmodule ListUtils do
	def sum([]), do: 0
	def sum([head | tail]), do: head + sum(tail)
end
```

Cond:
```
def call_status(call) do
	cond do
		call.ended_at != nil -> :ended
		call.started_at != nil -> :started
		true -> :pending
	end
end
```

Case:
```
def max(a,b) do
	case a >= b do
		true -> a
		false -> b
	end
end
```

With:
```
defp extract_email(%{"email" => email}), do: {:ok, email}
defp extract_email(_), do: {:error, "Email missing."}

defp extract_password(%{"password" => password}), do: {:ok, password}
defp extract_password(_), do: {:error, "Password missing."}

def extract_user(user) do
	with {:ok, email} <- extract_email(user),
		{:ok, password} <- extract_password(user) do
		{:ok, %{email: email, password: password}}
	end
end

extract_user(%{email: "john.doe@gmail.com"})
```