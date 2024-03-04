---
title: "Go Does Not Have Reference Variables"
date: 2024-02-29T14:00:09-06:00
categories: ["go"]
---

> To be clear, Go does not have reference variables, so Go does not have pass-by-reference function call semantics.
> [Dave Cheney](https://dave.cheney.net/2017/04/29/there-is-no-pass-by-reference-in-go)

### What is a reference variable?

In languages like C++ you can declare an _alias_, or an alternate name to an existing variable. This is called a reference variable.

```cpp
#include <stdio.h>

int main() {
  // integer type
  int a = 10;
  // reference type; type annotation: "int &"
  // means "reference to an integer variable" type
  int &b = a;
  int &c = b;

  // 10 10 10
  printf("%d %d %d\n", a, b, c);
  // reference variables share the same memory address
  // with the variable which they refer to;
  // 0x7ffeea4654f8 0x7ffeea4654f8 0x7ffeea4654f8
  printf("%p %p %p\n", &a, &b, &c); // here, & is "address of" operator

  // pointer type; type annotation: "int *"
  // means "pointer to an integer variable" type
  int *p1 = &a;
  int *p2 = &a;
  int *p3 = &a;

  // here, * is "deferencing"(or "content of") operator
  // 10 10 10
  printf("%d %d %d\n", *p1, *p2, *p3);

  // pointer variables have their own memory address
  // 0x7ffee82644e0 0x7ffee82644d8 0x7ffee82644d0
  printf("%p %p %p\n", &p1, &p2, &p3);

  return 0;
}
```

You can see that a, b, and c all refer to the same memory location. A write to a will alter the contents of b and c. This is useful when you want to declare reference variables in different scopes–namely function calls.

On the other hand, pointer variables hold memory addresses as their content. p1, p2, and p3 all hold the same memory address, but they are completely different variables and have their own memory addresses.

### Go does not have reference variables

Unlike C++, Go does not have reference variables.

It is NOT possible to create a Go program where two variables share the same storage location in memory. It is possible to create two variables whose contents point to the same storage location, but that is not the same thing as two variables who share the same storage location.

```go
package main

import "fmt"

func main() {
        // integer type
        var a int
        // pointer type; type annotation: "*int"
        var b, c *int = &a, &a

        // b and c holds the same memory address as their contents
        // 0xc000094018 0xc000094018
        fmt.Println(b, c)

        // but b and c are completely different variables with their own memory addresses
        // 0xc0000a2018 0xc0000a2020
        fmt.Println(&b, &c)
}
```

In this example, b and c hold the same value(the address of a), however, b and c themselves are stored in unique locations. Updating the contents of b would have no effect on c.

### There is no "reference type" in Go

What about struct and map and channel, they are reference types, no?

NOOOOO!

By the way, I'm not mentioning slice here because slice is a special data type associated with its "underlying array" in Go.

```go
package main

import "fmt"

type Person struct {
        Age int
}

func modifyAge(p Person) {
        p.Age = 100
}

func main() {
        john := Person{
                Age: 50,
        }

        modifyAge(john)

        fmt.Println(john.Age == 100) // false
}
```

If the struct `john` was a C++ style reference variable, we should see `true` to be printed out. But it's not.

So, we can conclude that Go does not have _pass-by-reference_ semantics because Go does not have reference variables.

### Maps in structs

Well, how would you explain this example?

```go
package main

import "fmt"

type Person struct {
        Skills map[string]int
}

func modifySkills(p Person) {
        p.Skills["Writing"] = 6
}

func main() {
        john := Person{
                Skills: map[string]int{
                        "Making Mistakes": 10,
                },
        }

        modifySkills(john)

        fmt.Printf("%+v", john) // {Skills:map[Making Mistakes:10 Writing:6]}
}
```

> A map value is a pointer to a runtime.hmap structure.
> [Dave Cheney](https://dave.cheney.net/2017/04/30/if-a-map-isnt-a-reference-variable-what-is-it)

So, `john.Skills` holds the pointer to the content of the map variable, and thus, `modifySkills` function modifies the content of the `Skills` map variable.

The same holds true for nested maps, structs, and channels.

### What is a pointer in Go?

Off-topic, but not entirely.

This Gist explains it awesomely.

```go
package main

import "fmt"

func main() {
        i, j := 42, 2701
        fmt.Println(i, j)
        fmt.Println(&i, &j)

        // you can read "&i" as "address of i"
        p := &i
        // var p *int
        // here, p's type is "pointer pointing to integers"
        fmt.Printf("%T\n", p)
        // *p
        // here, * is an operator that returns what p is pointing to
        // it is also called "dereferencing"
        fmt.Println(*p)
        // changing value of *p will change the value of i
        *p = 21
        fmt.Println(i)

        p = &j
        *p = *p / 37
        fmt.Println(j)

        // this function call mutates the value of i
        squareVal(&i)
        fmt.Println(i)
}

func squareVal(p *int) {
        *p *= *p
        // so, return a pointer or a value? up to ya!
        // if you return a pointer, the Go garbage collector will have something more todo with the heap.
        // just focus on readibility for now
        // consider trade-offs when you optimize
        fmt.Println(p, *p)
}
```

Alright, that's it for now.

Happy coding, Gophers!
