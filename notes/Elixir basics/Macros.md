One of the most important Elixir features, and help to reduce boilerplate and building DSL expressions by performing code transformations at compile time.

A macro is called at runtime, and receives a parsed Elixir code (parsed source representation) as input, and returns an alternative version of that code.
```
unless some_expression do
	block_1
else
	block_2
end
```
transformed into:
```
if some_expression do
	block_2
else
	block_1
end
```
