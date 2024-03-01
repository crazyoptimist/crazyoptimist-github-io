---
title: "Test Doubles in Unit Testing"
date: 2023-03-03T02:25:04-06:00
categories: ["tdd", "go"]
---
Test double is one of the key concepts of TDD(Test Driven Development). Test Double is a generic term for any case where you replace a production object for testing purposes.

There are various kinds of test doubles:  **Dummies**, **Stubs**, **Mocks**, **Spies**, **Fakes**.

Whew, what on earth is that? Alright, let's check them out one by one:

### Dummies

A dummy is an object that is passed to a function or method but is never actually used. Its purpose is to satisfy the function's signature, allowing it to be compiled and executed during testing. Dummies are often used when a function requires multiple arguments, but only some of them are needed for a particular test case.

Here's an example of a dummy in Go:

```go
func Add(a, b int, _ interface{}) int {
    return a + b
}

func TestAdd(t *testing.T) {
    result := Add(2, 3, nil)
    if result != 5 {
        t.Errorf("Expected 5, but got %d", result)
    }
}
```

In this example, the Add function takes three arguments: a, b, and `_`. The third argument is a dummy variable that is never actually used. We pass `nil` as the value of the dummy variable in the TestAdd function, which allows us to test the behavior of the Add function without worrying about the third argument. The test checks whether the result of adding 2 and 3 is equal to 5, which is the expected result.

Note that dummies are different from other test doubles like stubs or mocks, as they do not have any behavior or implementation. They are simply placeholders that allow the code to compile and run during testing.

### Stubs

A stub is an object that provides pre-defined responses to method calls. The purpose of a stub is to isolate the code being tested from its dependencies, allowing the test to focus on the behavior of the code itself. In Go, you can implement a stub by creating a struct that satisfies the interface being used by the code under test, and then defining pre-defined values or behaviors for its methods.

Here's an example of how to implement a stub in Go:

```go
type DB interface {
    Get(key string) (string, error)
    Set(key, value string) error
}

type StubDB struct {
    getFunc func(key string) (string, error)
    setFunc func(key, value string) error
}

func (s *StubDB) Get(key string) (string, error) {
    if s.getFunc != nil {
        return s.getFunc(key)
    }
    return "", errors.New("getFunc is not defined")
}

func (s *StubDB) Set(key, value string) error {
    if s.setFunc != nil {
        return s.setFunc(key, value)
    }
    return errors.New("setFunc is not defined")
}
```

In this example, we define a DB interface with Get and Set methods. We then define a StubDB struct that satisfies this interface, and includes two functions getFunc and setFunc that can be used to define the behavior of the stub. The Get and Set methods check whether getFunc and setFunc have been defined, respectively, and call them with the appropriate arguments if they have. If getFunc or setFunc has not been defined, the methods return an error indicating that the function is not defined.

To use this stub in a test, we can define the behavior of the stub by setting the getFunc and setFunc functions:

```go
func TestGetUser(t *testing.T) {
    db := &StubDB{
        getFunc: func(key string) (string, error) {
            return "test", nil
        },
    }
    user, err := db.Get("test")
    if err != nil {
        t.Errorf("Unexpected error: %v", err)
    }
    if user != "test" {
        t.Errorf("Expected 'test', but got '%s'", user)
    }
}
```

In this example, we create a StubDB object with a getFunc function that returns "test" and no error. We then call the Get method on the stub with "test" as the key, and check whether the result is "test". If the result is not "test", or if an error occurs, the test fails.

Using a stub like this allows us to test the behavior of the code under test without having to rely on the behavior of the actual database. We can define exactly what responses the database will provide in each test case, ensuring that the test remains isolated and reproducible.

### Spies

A spy is an object that records information about the calls made to it, such as the arguments passed in and the number of times it was called. This information can be used to verify that the code being tested is behaving correctly.

Here's an example of a spy in Go:

```go
type MyService struct {}

func (s *MyService) DoSomething(arg string) error {
    // some implementation
    return nil
}

type MySpy struct {
    Calls []string
}

func (s *MySpy) DoSomething(arg string) error {
    s.Calls = append(s.Calls, arg)
    return nil
}

func TestMyService(t *testing.T) {
    spy := &MySpy{}
    service := &MyService{}

    // Replace the real implementation with the spy
    service.DoSomething = spy.DoSomething

    // Call the service
    service.DoSomething("arg1")
    service.DoSomething("arg2")

    // Verify that the spy recorded the calls correctly
    if len(spy.Calls) != 2 {
        t.Errorf("Expected 2 calls, but got %d", len(spy.Calls))
    }
    if spy.Calls[0] != "arg1" {
        t.Errorf("Expected first call to be 'arg1', but got '%s'", spy.Calls[0])
    }
    if spy.Calls[1] != "arg2" {
        t.Errorf("Expected second call to be 'arg2', but got '%s'", spy.Calls[1])
    }
}
```

In this example, we have a MyService type with a DoSomething method that takes a string argument and returns an error. We also have a MySpy type with a DoSomething method that records the calls made to it in a slice.

In the TestMyService function, we create an instance of MySpy and an instance of MyService. We replace the real implementation of DoSomething with the implementation of DoSomething in MySpy. We then call DoSomething twice on MyService with different arguments.

Finally, we verify that the calls were recorded correctly by checking the length of the Calls slice and the values of the elements in the slice.

This is just a simple example, but in more complex scenarios, spies can be very useful for testing interactions between different parts of a system.

### Mocks

A mock is an object that simulates the behavior of a real object in a controlled way. It allows you to test your code in isolation from its dependencies by replacing them with mock objects. In the Go programming language, mocking is often done using interfaces and dependency injection.

Here's example of a use case of mocks.

Imagine we have an EmailSender interface and a UserNotifier struct that depends on it:

```go
package main

import "fmt"

type EmailSender interface {
	SendEmail(to string, subject string, body string) error
}

type UserNotifier struct {
	emailSender EmailSender
}

func NewUserNotifier(emailSender EmailSender) *UserNotifier {
	return &UserNotifier{emailSender: emailSender}
}

func (u *UserNotifier) NotifyUser(email string, message string) error {
	return u.emailSender.SendEmail(email, "Notification", message)
}

type RealEmailSender struct{}

func (r *RealEmailSender) SendEmail(to string, subject string, body string) error {
	fmt.Printf("Sending email to %s with subject %s and body %s\n", to, subject, body)
	return nil
}
```

In this example, UserNotifier depends on the EmailSender interface to send emails. The RealEmailSender implements this interface and sends emails. To test UserNotifier without actually sending emails, we can create a mock EmailSender:

```go
package main

import (
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
)

type MockEmailSender struct {
	sendEmailFunc func(to string, subject string, body string) error
}

func (m *MockEmailSender) SendEmail(to string, subject string, body string) error {
	return m.sendEmailFunc(to, subject, body)
}

func TestUserNotifier_NotifyUser(t *testing.T) {
	// Create a mock EmailSender
	mockEmailSender := &MockEmailSender{
		sendEmailFunc: func(to string, subject string, body string) error {
			assert.Equal(t, "test@example.com", to)
			assert.Equal(t, "Notification", subject)
			assert.Equal(t, "Hello, user!", body)
			return nil
		},
	}

	// Inject the mock into UserNotifier
	userNotifier := NewUserNotifier(mockEmailSender)

	// Execute the test
	err := userNotifier.NotifyUser("test@example.com", "Hello, user!")
	assert.NoError(t, err)
}
```

In this test, we create a MockEmailSender that implements the EmailSender interface. We define the behavior of the SendEmail method using a function that receives the input arguments and checks if they are as expected. Then, we inject the mock into UserNotifier and call NotifyUser to make sure it behaves correctly.

### Fakes

A fake is a simplified implementation of a real object that is used to test code that depends on the real object. Fakes are useful when the real object is too complex or too slow to use during testing.

Here's an example of a fake in Go:

```Go
type MyService interface {
    DoSomething(arg string) error
}

type MyFake struct {
    LastArg string
}

func (f *MyFake) DoSomething(arg string) error {
    f.LastArg = arg
    return nil
}

func TestMyCode(t *testing.T) {
    // Create a fake object
    fake := &MyFake{}

    // Inject the fake into the code being tested
    myCode := NewMyCode(fake)

    // Call the code being tested
    myCode.DoSomethingWithMyService()

    // Verify that the fake was called correctly
    if fake.LastArg != "arg1" {
        t.Errorf("Expected last argument to be 'arg1', but got '%s'", fake.LastArg)
    }
}
```

In this example, we have a MyService interface with a DoSomething method that takes a string argument and returns an error. We also have a MyFake type that implements the MyService interface by recording the last argument passed in.

In the TestMyCode function, we create an instance of MyFake, and then we inject it into the NewMyCode function which takes a MyService parameter. We then call DoSomethingWithMyService on the myCode object.

Finally, we verify that the fake was called correctly by checking the value of the LastArg field in the MyFake object.

This is a simple example, but in more complex scenarios, fakes can be very useful for testing code that depends on external systems or services that may not be available during testing, such as databases or third-party APIs. Fakes can also be used to test error handling or edge cases that may be difficult to reproduce with real objects.

It's important to note that while fakes can be useful for testing, they should be used carefully, as they may not accurately reflect the behavior of the real object being replaced. It's also important to ensure that the behavior of the fake closely matches that of the real object being replaced to avoid false positives in your tests.


Phew~

That's huge, if you've read through this far, I assume you are a Gopher :).

Happy coding and have fun!
