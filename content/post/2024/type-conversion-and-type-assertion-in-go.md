---
title: "Type Conversion and Type Assertion in Go"
date: 2024-03-15T16:01:30-05:00
categories: ["go"]
---

## Type conversion

The expression `T(v)` converts the value `v` to the type `T`.

In Go, assignment between items of different type requires an explicit conversion.

Here's an example.

```go
package main

import (
	"fmt"
	"math"
)

func main() {
	var x, y int = 11, 12
	f := math.Sqrt(float64(x*x + y*y))
	var z uint = uint(f)
	fmt.Println(x, y, z)
}
```

## Type assertion

Type assertion provides access to an interface value's underlying concrete value.

`t := i.(T)`

This statement asserts that the interface value `i` holds the concrete type `T` and assigns the underlying `T` value to the variable `t`.

If `i` does not hold a `T`, the statement will trigger a panic.

To test whether an interface value holds a specific type, a type assertion can return two values: the underlying value and a boolean value that reports whether the assertion succeeded.

`t, ok := i.(T)`

If `i` holds a `T`, then `t` will be the underlying value and `ok` will be `true`.

If not, `ok` will be `false` and `t` will be the zero value of type `T`, and no panic occurs.

Here's an example.

```go
package main

import "fmt"

func main() {
	var i interface{} = "hello"

	s := i.(string)
	fmt.Println(s) // hello

	s, ok := i.(string)
	fmt.Println(s, ok) // hello true

	f, ok := i.(float64)
	fmt.Println(f, ok) // 0 false

	f = i.(float64) // panic
	fmt.Println(f)
}
```

Note the similarity between this syntax and that of reading from a map.

`val, ok := zoo["cat"]`

In this statement, `val` is assigned the value stored under the key "cat". If that key doesn’t exist, `val` is the value type’s zero value. `ok` is a boolean that is `true` if the key exists in the map, and `false` if not.


## Bibliography

- https://go.dev/tour/basics/13
- https://go.dev/tour/methods/15
- https://go.dev/blog/maps
