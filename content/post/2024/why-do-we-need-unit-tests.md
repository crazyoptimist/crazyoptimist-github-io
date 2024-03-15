---
title: "Why Do We Need Unit Tests?"
date: 2024-03-15T15:29:42-05:00
categories: ["tdd"]
---

## What is unit testing?

Unit testing is the process where you test the smallest functional unit of code.

Software testing helps ensure code quality, and it's an integral part of software development.

It's a software development best practice to write software as small, functional units then write a unit test for each code unit.

You can first write unit tests as code. Then, run that test code automatically every time you make changes in the software code. This way, if a test fails, you can quickly isolate the area of the code that has the bug or error.

Unit testing enforces modular thinking paradigms and improves test coverage and quality. Automated unit testing helps ensure you or your developers have more time to concentrate on coding.

## What is a unit test?

A unit test is a block of code that verifies the accuracy of a smaller, isolated block of application code, typically a function or method. The unit test is designed to check that the block of code runs as expected, according to the developer’s theoretical logic behind it. The unit test is only capable of interacting with the block of code via inputs and captured asserted (true or false) output.

A single block of code may also have a set of unit tests, known as test cases. A complete set of test cases cover the full expected behavior of the code block, but it’s not always necessary to define the full set of test cases.

When a block of code requires other parts of the system to run, you can’t use a unit test with that external data. The unit test needs to run in isolation. Other system data, such as databases, objects, or network communication, might be required for the code’s functionality. If that's the case, you should use data stubs instead. It’s easiest to write unit tests for small and logically simple blocks of code.

## What should you write unit tests for?

**Logic checks**

Does the system perform the right calculations and follow the right path through the code given a correct, expected input? Are all paths through the code covered by the given inputs?

**Boundary checks**

For the given inputs, how does the system respond? How does it respond to typical inputs, edge cases, or invalid inputs?

Let’s say you expect an integer input between 3 and 7. How does the system respond when you use a 5 (typical input), a 3 (edge case), or a 9 (invalid input)?

**Error handling**

When there are errors in inputs, how does the system respond? Is the user prompted for another input? Does the software crash?

**Object-oriented checks**

If the state of any persistent objects is changed by running the code, is the object updated correctly?

## Why do we need unit tests at all?

Unit testing benefits software development projects in many ways.

**Efficient bug discovery**

If there are any input, output, or logic-based errors within a code block, your unit tests help you catch them before the bugs reach production. When code changes, you run the same set of unit tests—alongside other tests such as integration tests—and expect the same results. If tests fail (also called broken tests) it indicates regression-based bugs.

Unit testing also helps finds bugs faster in code. Your developers don’t spend a large amount of time on debugging activities. They can quickly pinpoint the exact part of the code that has an error.

**Documentation**

It's important to document code to know exactly what that code is supposed to be doing. That said, unit tests also act as a form of documentation.

Other developers read the tests to see what behaviors the code is expected to exhibit when it runs. They use the information to modify or refactor the code. Refactoring code makes it more performant and well-composed. You can run the unit testing again to check that code works as expected after changes.

## When is unit testing less beneficial?
Unit testing isn’t always required for every single test case in every single block of code in every single project. Here are some examples of when unit testing could potentially be omitted.

**When time is constrained**

Even with generative unit testing frameworks, writing new unit tests takes a significant amount of your developers' time. While input and output-based unit tests may be easy to generate, logic-based checks are more difficult.

Once your developers start writing tests, they also see refactoring opportunities in the block of code and get distracted from completing them. This can lead to extended development timelines and budget issues.

**UI/UX applications**

When the main system is concerned with look and feel rather than logic, there may not be many unit tests to run. Other types of testing, such as manual testing, are a better strategy than unit testing in these cases.

**Legacy codebases**

Writing tests to wrap around existing legacy code can prove to be near impossible, depending on the style of the written code. Because unit tests require dummy data, it can also be too time-intensive to write unit tests for highly interconnected systems with a lot of data parsing.

**Rapidly evolving requirements**

Depending on the project, the software can grow, change directions, or have whole parts scrapped altogether in any given work sprint. If requirements are likely to change often, there's not much reason to write unit tests each time a block of code is developed.


That's pretty much it. Credit goes to [AWS](https://aws.amazon.com/what-is/unit-testing/).

Happy testing!
