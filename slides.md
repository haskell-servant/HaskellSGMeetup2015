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

--

- Change APIs in a type-safe manner

---

.center[
(compile & start server)
]

---

# Get & HasServer

``` haskell
data Get a
  deriving Typeable
```

--

``` haskell
serve :: HasServer layout => Proxy layout -> Server layout -> Application
```

--

``` haskell
class HasServer layout where
  type Server layout :: *
  route :: ...
```

--

``` haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route = ...
```

---
# Subpaths



---
  - Alternative
  - QueryParam
  - HasServer (overview graph?)

  - Post, Put, Delete
  - QueryParam, QueryParams, QueryFlag
  - Capture
  - ReqBody
  - Header
  - Matrix
  - Raw (aka wai FFI)

---

# HasClient

---

# HasDocs



















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


