* **Numbers** - self-explanatory.
* **Atoms** - named constants. For example, `:an_atom` or `:"Another atom"`. Kept in an atom table, and variable of an atom only contains a reference to the entry (text) of that table. Also represent boolean values, but those have syntax sugar and don't need colon in front of the value. Also, `nil` is an atom too.
* **Tuples** - untyped structures. For example `{"Bob", 27}`:
	```
	person = {"Bob", 27}
	older_person - put_elem(person, "Bob", 28)
	```

* **Lists** - variable-sized collections of data. They are not arrays, but linked lists.
	```
	prime_numbers = [2, 3, 5, 7]
	number = Enum.at(prime_numbers, 2) # Returns: 5
	updated_prime_numbers = [11 | prime_numbers]
	```
* **Maps** - key-value store, where keys can be any term. Used for dynamically sized data and simple fixed-size records. 
	```
	empty_map = %{}

	squares = %{1 => 1, 2 => 4, 3 => 9}
	squares = Map.put(squares, 4, 16)
	```

	```
	bob = %{:name => "Bob", :age => "27"}
	bob[:works_at]
	# Returns: nil
	```

* **Binaries and bitstrings** - binaries are chunk of bytes. For example,  `<<<1, 2, 3>>` is 3-byte binary, where each value uses 8-bits. Here, single value spans two bytes: `<<257::16>>`. Bitstring looks like this: `<<1::1, 0::1, 1::1>>`. (==Consecutive sequences ob bytes==)
* **Strings** - does not have strings, and instead uses binary or a list type to represent them. Can declare string using ==sigils==: `~s("This is a string.")` (helps to avoid writing escape characters). 
* **Functions** - can be assigned to variables, passed to other functions:
```
square = fn x -> 
	x * x
end

square.(5)

# Declaring anonymous function shorthand, capture operator.
Enum.each(
	[1, 2, 3],
	&IO.puts/1
)
```
* **Other types** - reference (uniquely identify BEAM instance, 2^82 values), PIDs (identify Erlang processes), port identifiers (file I/O, external programs).
##### Higher level data types
`Range`, `Keyword`, `MapSet`, `Date`, `Time`, `NaiveDateTime`, and `DateTime`.
* **Range** - an enumerable, example is `1..2`. 
* **Keyword lists** - each element is two-value tuple, where first element is an atom, ant the second can be anything. Mostly used for passing arbitrary number or arguments to functions. ==Can contain multiple value for the same key==.
	```
	days = [monday: 1, tuesday: 2, wednesday: 3]

	# Shorthand example (still, only two arguments here):
	IO.inspect([100, 200, 300], width: 3, limit: 1)
	```

* **MapSet** - stores unique values in a set. Also an enumerable.
* **Times and dates** - `~D[2023-01-31]`, `~T[11:59:12.00007]`, `~N[2023-01-31 11:59:12.000007]`, `~U[2023-01-31 11:59:12.000007Z]`.
* **IO lists** - for building output that can be forwarded to an I/O device. In other words, for incrementally building a stream of bytes. `[[[~c"He"], "llo,"], " worl", "d!"]`, complexity for adding an element is `O(1)`.

### Immutability
Every function returns the new, modified version of the input data. However, memory is shared as much as possible. (The data is shallow copied). ==Allows for side-effect free data transformations.== Allows for atomic in-memory operations.

> Side-effect-free functions are easier to analyze, understand, and test. They have
> well-defined inputs and outputs. When you call a function, you can be sure no variable
> will be implicitly changed. Whatever the function does, you must take its result and do
> something with it.

```
def complex_transformation(data) do
	data
	|> transformation_1(...)
	|> transformation_2(...)
	|> transformation_3(...)
	|> transformation_n(...)
end
```

Tuples:
```
a_tuple = {a, b, c}
new_tuple = put_elem(a_tuple, 1, b2)
```

![[Pasted image 20240920150320.png]]

Lists:
When `n-th` element of the list is modified, elements up to `n-1` are shallow copied, and the rest is shared.  This is why adding elements to the end is expensive.
![[Pasted image 20240920150735.png]]
Inexpensive append:
![[Pasted image 20240920151116.png]]
