---
title: "Test Doubles in Unit Testing"
date: 2023-03-03T02:25:04-06:00
categories: ["tdd"]
---

"Test Double" is a generic term for any case where you replace a production object for testing purposes.

I believe the following description provides a more intuitive understanding of the concept.

A Test Double is an object that stands in for a real object in a test, similar to how a stunt double stands in for an actor in a movie.

There are various kinds of test doubles:  **Dummies**, **Stubs**, **Mocks**, **Spies**, **Fakes**.

Whew, what on earth is that? Alright, let's check 'em out one by one.

### Dummies

A dummy is an object that is passed to a function but is never actually used.

Its purpose is to satisfy the function's signature, allowing it to be compiled and executed during testing. Dummies can be used when a function requires multiple arguments, but only some of them are needed for a particular test case.

Dummies are different from other test doubles like stubs or mocks, as they do not have any behavior or implementation. They are simply placeholders that allow the code to compile and run during testing.

Up to this point, I haven't found any practical usage examples of dummies. I believe you will rarely use it if you properly separate concerns in your code.

### Stubs

A stub is an object that provides pre-defined responses to calls. The purpose of a stub is to isolate the unit being tested from its dependencies, allowing the test to focus on the behavior of the unit itself.

In Go, you can define an interface that is implemented by a unit being tested. Then, you can create a stub easily by implementing the same interface. Pre-defined responses are usually hardcoded inside the stubs.

Here's an example of a stub in Go:

```go
type DB interface {
    Get(key string) (string, error)
    Set(key, value string) error
}

type stubDB struct {}

// interface check
var _ DB = (*stubDB)(nil)

func (s *stubDB) Get(key string) (string, error) {
    if key == "" {
        return nil, errors.New("key can not be empty")
    }
    // hardcoded responses
    if key == "bob" {
        return "bob's value", nil
    }
    if key == "tom" {
        return "tom's value", nil
    }
}

func (s *stubDB) Set(key, value string) error {
    if key == "" {
        return errors.New("key can not be empty")
    }
    return nil
}
```

Now, you can inject `stubDB` into the unit being tested, as dependency injection is commonly used in Go.

Using a stub like this allows us to test the behavior of the code under test without having to rely on the behavior of the actual database. We can define exactly what responses the database will provide in each test case, ensuring that the test remains isolated and reproducible.

### Spies

A spy is a stub with an extra functionality that records information about the calls made to it, such as the arguments passed in and the number of times it was called. This information can be used to verify that the unit being tested behaves correctly.

Here's an example of a spy in Go:

```go
type EmailService interface {
	Send(msg string) error
}
```

```go
type emailService struct{}

var _ EmailService = (*emailService)(nil)

func (s *emailService) Send(msg string) error {
	// actual implementation goes here
	fmt.Println(msg)
	return nil
}
```

```go
type spyEmailService struct {
	MessageCount int
}

var _ EmailService = (*spyEmailService)(nil)

func (s *spyEmailService) Send(msg string) error {
	s.MessageCount += 1
	return nil
}
```


```go
func TestEmailService(t *testing.T) {
	service := &spyEmailService{}

	service.Send("msg1")
	service.Send("msg2")

	if service.MessageCount != 2 {
		t.Errorf("Expected 2 calls, but got %d", service.MessageCount)
	}
}
```

This is just a conceptional example, but in complex scenarios, spies can be very useful for testing interactions between different parts of a system.

### Mocks

A mock is a pre-programmed object with specifications of the calls they are expected to receive.

Mocks can throw an exception if they receive a call they don't expect and are checked during verification to ensure they got all the calls they were expecting.

The main difference between a mock and most of the other test doubles is that mocks do behavioral verification, whereas other test doubles do state verification. With behavioral verification, you end up testing that the implementation of the system under test is as you expect, whereas with state verification the implementation is not tested, rather the inputs and the outputs to the system are validated.

Mocks are generally considered the hardest type of test double to use. In most unit tests, you will only use stubs and spies.

### Fakes

A fake is an object that has a working implementation, but usually takes some shortcut which makes it not suitable for production.

One of the common examples of using a Fake is an in-memory database - typically you want your database to be able to save data somewhere between application runs, but when writing unit tests if you have a fake implementation of your database APIs that are store all data in memory, you can use these for unit tests and not break abstraction as well as still keep your tests fast.

That's it for now.

Happy coding! ;)
