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

``` haskell
serve :: HasServer layout => Proxy layout -> Server layout -> Application
```

``` haskell
class HasServer layout where
  type Server layout :: *
  route :: ...
```

``` haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route = ...
```

---

# Subpaths

``` haskell
data (path :: k) :> a
infixr 9 :>
```

``` haskell
instance (KnownSymbol path, HasServer sublayout) =>
  HasServer (path :> sublayout) where
    type Server (path :> sublayout) = Server sublayout
    route = ...
```

---

# Alternatives

``` haskell
data a :<|> b = a :<|> b
infixr 8 :<|>
```

``` haskell
instance (HasServer a, HasServer b) => HasServer (a :<|> b) where
  type Server (a :<|> b) = Server a :<|> Server b
  route = ...
```

---

# QueryParam

``` haskell
data (path :: k) :> a
infixr 9 :>
```

``` haskell
data QueryParam sym a
```

``` haskell
instance (KnownSymbol sym, FromText a, HasServer sublayout)
      => HasServer (QueryParam sym a :> sublayout) where
  type Server (QueryParam sym a :> sublayout) =
    Maybe a -> Server sublayout
  route = ...
```


---

# Overview

- Combinators to specify an api as a type alias (`Get`, `:>`, `:<|>`,
  `QueryParams`, &c.)
- `Server` type family
- Function to convert a `Server` into an `Application` (`serve`)

--

## Goals

- little boilerplate
- type safety
- separation of concerns

---

# Post, Put, Delete

``` haskell
data Post a
  deriving Typeable
```

``` haskell
instance ToJSON a => HasServer (Post a) where
  type Server (Post a) = EitherT (Int, String) IO a
  route = ...
```

``` haskell
data Put a
  deriving Typeable
```

``` haskell
instance ToJSON a => HasServer (Put a) where
  type Server (Put a) = EitherT (Int, String) IO a
  route = ...
```

``` haskell
data Delete
  deriving Typeable
```

``` haskell
instance HasServer Delete where
  type Server Delete = EitherT (Int, String) IO ()
  route = ...
```

---

# QueryParam

``` haskell
data QueryParam sym a
```

``` haskell
instance (KnownSymbol sym, FromText a, HasServer sublayout)
      => HasServer (QueryParam sym a :> sublayout) where
  type Server (QueryParam sym a :> sublayout) =
    Maybe a -> Server sublayout
  route = ...
```

---

# QueryParams

``` haskell
data QueryParams sym a
```

``` haskell
instance (KnownSymbol sym, FromText a, HasServer sublayout)
      => HasServer (QueryParams sym a :> sublayout) where
  type Server (QueryParams sym a :> sublayout) =
    [a] -> Server sublayout
  route = ...
```

---

# QueryFlag

``` haskell
data QueryFlag sym
```

``` haskell
instance (KnownSymbol sym, HasServer sublayout)
      => HasServer (QueryFlag sym :> sublayout) where
  type Server (QueryFlag sym :> sublayout) =
    Bool -> Server sublayout
  route = ...
```

---

# Capture

``` haskell
data Capture sym a
```

``` haskell
instance (KnownSymbol capture, FromText a, HasServer sublayout)
      => HasServer (Capture capture a :> sublayout) where
  type Server (Capture capture a :> sublayout) =
     a -> Server sublayout
  route = ...
```

---

# ReqBody

``` haskell
data ReqBody a
```

``` haskell
instance (FromJSON a, HasServer sublayout)
      => HasServer (ReqBody a :> sublayout) where
  type Server (ReqBody a :> sublayout) =
    a -> Server sublayout
  route = ...
```

---

# Other Combinators

- Headers
- Matrix Parameters

---

# Raw

``` haskell
data Raw
```

``` haskell
instance HasServer Raw where
  type Server Raw = Application
  route = ...
```

---

# HasClient

``` haskell
client :: HasClient layout => Proxy layout -> Client layout
```

``` haskell
class HasClient layout where
  type Client layout :: *
  clientWithRoute :: ...
```

``` haskell
instance FromJSON result => HasClient (Get result) where
  type Client (Get result) = BaseUrl -> EitherT String IO result
  clientWithRoute = ...
```

``` haskell
instance (KnownSymbol sym, ToText a, HasClient sublayout)
      => HasClient (QueryParam sym a :> sublayout) where
  type Client (QueryParam sym a :> sublayout) =
    Maybe a -> Client sublayout
  clientWithRoute = ...
```

---

# HasDocs

``` haskell
docs :: HasDocs layout => Proxy layout -> API
```

``` haskell
markdown :: API -> String
```

``` haskell
class HasDocs layout where
  docsFor :: ...
```

















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


