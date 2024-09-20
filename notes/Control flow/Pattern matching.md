Equality `=` operator is not an assignment, but a match operator. When "assigning" value to variables, left side is a ==pattern==, and the right side is an ==expression==. A variable always matches to the right side term, therefore it becomes bound to the value of that term.

Tuple pattern matching:
```
{name, age} = {"Bob", 27}
{:person, name, age} = {:person, "Bob", 27}
{{year, month, day}, time} = :calendar.local_time()
{_, time} = :calendar.local_time()
{_, {hour, _, _}} = :calendar.local_time()
{a, a, a} = {127, 127, 1} # Fails.

expected_name = "Bob"
{^expected_name, _} = {"Bob", 25}
 %{name: name, age: age} = %{name: "Bob", age: 25} # Matching maps.
 [_, {name, _}, _] = [{"Bob", 25}, {"Alice", 30}, {"John", 35}] # Note: good for highlighting code in steps for slide.
```

> Whenever a variable name exists in the left-side pattern, it always matches the corresponding right-side term. Additionally, the variable is bound to the term it matches.

Lists:
```
[head | tail] = [1, 2, 3]
head # 1
tail # [2, 3]
```


> iex(2)> a = 1 + 3
> 4
> Let’s break down what happens here:
> 1. The expression on the right side is evaluated.
> 2. The resulting value is matched against the left-side pattern.
> 3. Variables from the pattern are bound.
> 4. The result of the match expression is the result of the right-side term.

Chaining:
`a = (b = 1 + 3)`
`date_time = {_, {hour, _, _}} = :calendar.local_time()`

#### Functions
(3.2. Matching with functions)