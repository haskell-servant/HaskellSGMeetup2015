name: inverse
layout: true
class: center, middle, inverse
---
# servant

The minimalist webservice framework in Haskell

Haskell Meetup, The Office, Singapore

Wednesday, January 28, 2015

Julian Arni & Sönke Hahn

---
layout: false

# Overview

- Motivational Example
- Basic Combinators
  - Get
  - Sub
  - Post, Put, Delete
  - Alternative
  - QueryParam, QueryParams, QueryFlag
  - Capture
  - Header
  - ReqBody
  - Raw

  - Matrix

- Classes
  - todo, Julian!!!
- Writing Combinators
---
name: Motivational
layout: true
.left-column[
### Motivational Example
]
---

# Motivational Example

--

- Define a REST API as a type ( **just** the API)

--

- Generate client API calls

--

- Implement servers

---

Get

~~~ {.haskell}
import Servant

data Person = Person { name :: String }

alice :: Person
alice = Person "alice"

type Api = Get Person
~~~
--
~~~ {.haskell}
app :: Server Api
app = return alice
~~~


- Encapsulates *just* the API
- Separation of concerns
- Boilerplate

---


--

bla

## rest
















---
template: inverse

## Classes
---
name: Motivational
layout: true
.left-column[
### Motivational Example
### Basic Combinators
### Classes
]
---
.right-column[
## Classes
]
---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
]
---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
- Currently:
]

---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
- Currently:
  * [HasServer](http://hackage.haskell.org/package/servant-server)
]

---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
- Currently:
  * [HasServer](http://hackage.haskell.org/package/servant-server)
  * [HasClient](http://hackage.haskell.org/package/servant-client)
]

---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
- Currently:
  * [HasServer](http://hackage.haskell.org/package/servant-server)
  * [HasClient](http://hackage.haskell.org/package/servant-client)
  * [HasDocs](http://hackage.haskell.org/package/servant-docs)
]
---
.right-column[
## Classes

- Responsible for describing the functionality of each combinator.
- Currently:
  * [HasServer](http://hackage.haskell.org/package/servant-server)
  * [HasClient](http://hackage.haskell.org/package/servant-client)
  * [HasDocs](http://hackage.haskell.org/package/servant-docs)
  * [HasJQ](http://hackage.haskell.org/package/servant-jquery)
]


