# Servant

The minimalist webservice framework in Haskell

Haskell Meetup, The Office, Singapore

Wednesday, January 28, 2015

Julian Arni & Sönke Hahn

---

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

------------------------------------------------------------------------------
* Example: model an existing API
* GHCJS
