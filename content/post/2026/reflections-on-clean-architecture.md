---
title: "Reflections on Clean Architecture"
date: 2026-04-09T21:51:27-05:00
categories: ["architecture", "go", "tdd"]
---
Looking back at **Clean Architecture** by Uncle Bob. Funny how these principles are starting to feel like brand-new concepts again. :)
### Uncle Bob
- The goal of software architecture is to minimize the human resources required to build and maintain the required system.
- The only way to go fast, is to go well.
- Any organization that designs a system will produce a design whose structure is a copy of the organization's communication structure. (Conway's law)

### SOLID
- SRP: _Each software module has one, and only one, reason to change. (This is NOT "A function should do one, and only one, thing, and do it well.")_ A module should be responsible to one, and only one, actor. (actor == user or stakeholder)

- OCP: _For software systems to be easy to change, they must be designed to allow the behavior of those systems to be changed by adding new code, rather than changing existing code._ A software artifact should be open for extension but closed for modification.

- LSP: _To build software systems from interchangeable parts, those parts must adhere to a contract that allows those parts to be substituted one for another._ If for each object o1 of type S there is an object o2 of type T such that for all programs P defined in terms of T, the behavior of P is unchanged when o1 is substituted for o2 when S is a subtype of T.

- ISP: _Avoid depending on things that aren't used._

- DIP: _The code that implements high-level policy should not depend on the code that implements low-level details. Rather, details should depend on policies._

### Clean Architecture

- _Independent of frameworks._ The architecture does not depend on the existence of some library of feature-laden software. This allows you to use such frameworks as tools, rather than forcing you to cram your system into their limited constraints.
- _Testable._ The business rules can be tested without the UI, database, web server, or any other external element.
- _Independent of the UI._ The UI can change easily, without changing the rest of the system. A web UI could be replaced with a console UI, for example, without changing the business rules.
- _Independent of the database._ You can swap out Oracle or SQL Server for Mongo, BigTable, CouchDB, or something else. Your business rules are bound to the database.
- _Independent of any external agency._ In fact, your business rules don't know anything at all about the interfaces to the outside world.

### Clean Architecture Implementation

- Dependency Rule: Source code dependencies must point only inward, toward higher-level policies.
- Don't marry the framework! You can use the framework - just don't couple to it. Keep it at arm's length.
- Database is a detail. Web is a detail. Framework is a detail.
