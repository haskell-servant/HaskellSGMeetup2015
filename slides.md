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
- Writing Combinators
---
name: Motivational
layout: true
.left-column[
### Motivational Example
]
---
.right-column[
# Motivational Example
]
---
.right-column[
# Motivational Example

- Define a REST API as a type alias
]
---
.right-column[
# Motivational Example

- Define a REST API as a type alias
- Generate client API calls

]
---
.right-column[
# Motivational Example

- Define a REST API as a type alias
- Generate client API calls
- Implement servers
]
---

.right-column[
# Motivational Example

- Define a REST API as a type alias
- Generate client API calls
- Implement servers
- Change APIs in a type-safe manner
]
---

name: Combinators
layout: true
.left-column[
### Motivational Example
### Basic Combinators
]
---

.right-column[
# Get & HasServer

``` haskell
data Get a
  deriving Typeable
```

``` haskell
serve :: HasServer layout =>
  Proxy layout -> Server layout -> Application
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
]
---

.right-column[
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
]
---

.right-column[
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

]
---

.right-column[
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

]
---

.right-column[
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
]
---

.right-column[
# Digest

- Combinators to specify an api as a type alias (`Get`, `:>`, `:<|>`,
  `QueryParam`, &c.)
- `Server` type family
- Function to convert a `Server` into an `Application` (`serve`)

]

---

.right-column[
# Digest

- Combinators to specify an api as a type alias (`Get`, `:>`, `:<|>`,
  `QueryParam`, &c.)
- `Server` type family
- Function to convert a `Server` into an `Application` (`serve`)

## Goals

- little boilerplate
- type safety
- separation of API and application logic
]
---

.right-column[
# Other Combinators

- Post, Put, Delete
- QueryParams, QueryFlag
- ReqBody
- Headers
- Matrix Parameters
]
---

.right-column[
# Raw

``` haskell
data Raw
```

``` haskell
instance HasServer Raw where
  type Server Raw = Application
  route = ...
```
]
















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

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication
```
]

---
.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```
]
---

.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived

toApplication :: RoutingApplication -> Application
```
]
---

.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived

* toApplication :: RoutingApplication -> Application

```
]
---

.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived

* toApplication :: RoutingApplication -> Application

```
* The only "central" code.
]

---
.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```

```haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route Proxy action request respond
    | pathIsEmpty request &&
      requestMethod request == methodGet = do
          e <- runEitherT action
          respond . succeedWith $ case e of
              Right output ->
                responseLBS ok200
                            [("Content-Type", "application/json")]
                            (encode output)
              Left (status, message) ->
                responseLBS (mkStatus status (cs message))
                            []
                            (cs message)
    | pathIsEmpty request && requestMethod request /= methodGet =
        respond $ failWith WrongMethod
    | otherwise = respond $ failWith NotFound

```

]

---
.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```

```haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route Proxy action request respond
    | pathIsEmpty request &&
      requestMethod request == methodGet = do
*         e <- runEitherT action
          respond . succeedWith $ case e of
              Right output ->
                responseLBS ok200
                            [("Content-Type", "application/json")]
                            (encode output)
              Left (status, message) ->
                responseLBS (mkStatus status (cs message))
                            []
                            (cs message)
    | pathIsEmpty request && requestMethod request /= methodGet =
        respond $ failWith WrongMethod
    | otherwise = respond $ failWith NotFound

```

]
---
.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```

```haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route Proxy action request respond
    | pathIsEmpty request &&
      requestMethod request == methodGet = do
*         e <- runEitherT action
          respond . succeedWith $ case e of
*             Right output ->
*               responseLBS ok200
*                           [("Content-Type", "application/json")]
*                           (encode output)
              Left (status, message) ->
                responseLBS (mkStatus status (cs message))
                            []
                            (cs message)
    | pathIsEmpty request && requestMethod request /= methodGet =
        respond $ failWith WrongMethod
    | otherwise = respond $ failWith NotFound

```

]
---
.right-column[

## Get

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```

```haskell
instance ToJSON result => HasServer (Get result) where
  type Server (Get result) = EitherT (Int, String) IO result
  route Proxy action request respond
    | pathIsEmpty request &&
      requestMethod request == methodGet = do
*         e <- runEitherT action
          respond . succeedWith $ case e of
              Right output ->
                responseLBS ok200
                            [("Content-Type", "application/json")]
                            (encode output)
*             Left (status, message) ->
*               responseLBS (mkStatus status (cs message))
*                           []
*                           (cs message)
    | pathIsEmpty request && requestMethod request /= methodGet =
        respond $ failWith WrongMethod
    | otherwise = respond $ failWith NotFound

```

]

---

.right-column[
## Alternative

```haskell
class HasServer layout where
  type Server layout :: *
  route :: Proxy layout -> Server layout -> RoutingApplication

type RoutingApplication =
     Request
  -> (RouteResult Response -> IO ResponseReceived)
  -> IO ResponseReceived
```

```haskell
instance (HasServer a, HasServer b) => HasServer (a :<|> b) where
    type Server (a :<|> b) = Server a :<|> Server b
    route Proxy (a :<|> b) request respond =
        route pa a request $ \ mResponse ->
          if isMismatch mResponse
             then route pb b request $
                \mResponse' -> respond (mResponse <> mResponse')
             else respond mResponse
    where pa = Proxy :: Proxy a
          pb = Proxy :: Proxy b
```
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
---

.right-column[
# HasClient

``` haskell
client :: HasClient layout => Proxy layout -> Client layout
```

``` haskell
class HasClient layout where
  type Client layout :: *
  clientWithRoute :: Proxy layout -> Req -> Client layout
```

``` haskell
instance FromJSON result => HasClient (Get result) where
  type Client (Get result) = BaseUrl -> EitherT String IO result
 clientWithRoute Proxy req host = performRequestJSON H.methodGet req 200 host
```
]
---

.right-column[
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
]
---

name: inverse
layout: true
class: center, middle

---
(Writing your own combinator)


---
layout: false

## The expression problem

> The goal is to define a datatype by cases, where one can add new cases to the
> datatype and new functions over the datatype, without recompiling existing
> code, and while retaining static type safety (e.g., no casts).
>  __Philip Wadler, *The Expression Problem*, 1998__

--

* This is one of the things the combinator/classes design solves.


---
## The expression problem

--

|            | HasServer        | HasClient              | HasDocs             |
|------------|------------------|------------------------|---------------------|
|`Get a`     | serve `a`        | get the `a`            | document `a`        |
|`a :<∣> b`  | serve `a` and `b`| get either `a` or `b`  | document them both  |
|`ReqBody a` | pass `a` as arg  | send `a`  via req body | document `a`'s JSON |

---
## The expression problem


|            | HasServer        | HasClient              | HasDocs  | ...
|------------|------------------|------------------------|--------------|----|
|`Get a`     | serve `a`        | get the `a`            | document `a` | |
|`a :<∣> b`  | serve `a` and `b`| get either `a` or `b`  | document them both | |
|`ReqBody a` | pass `a` as arg  | send `a`  via req body | document `a`'s JSON | |
| ... | | | | | |

---

## The expression problem


|            | HasServer        | HasClient              | HasDocs  | ...
|------------|------------------|------------------------|--------------|----|
|`Get a`     | serve `a`        | get the `a`            | document `a` | |
|`a :<∣> b`  | serve `a` and `b`| get either `a` or `b`  | document them both | |
|`ReqBody a` | pass `a` as arg  | send `a`  via req body | document `a`'s JSON | |
| ... | | | | | |

* Types (that are instances of servant classes) are the constructors

---

## The expression problem


|            | HasServer        | HasClient              | HasDocs  | ...
|------------|------------------|------------------------|--------------|----|
|`Get a`     | serve `a`        | get the `a`            | document `a` | |
|`a :<∣> b`  | serve `a` and `b`| get either `a` or `b`  | document them both | |
|`ReqBody a` | pass `a` as arg  | send `a`  via req body | document `a`'s JSON | |
| ... | | | | | |

* Types (that are instances of servant classes) are the constructors
* Class methods are the function signature

---

## The expression problem


|            | HasServer        | HasClient              | HasDocs  | ...
|------------|------------------|------------------------|--------------|----|
|`Get a`     | serve `a`        | get the `a`            | document `a` | |
|`a :<∣> b`  | serve `a` and `b`| get either `a` or `b`  | document them both | |
|`ReqBody a` | pass `a` as arg  | send `a`  via req body | document `a`'s JSON | |
| ... | | | | | |

* Types (that are instances of servant classes) are the constructors
* Class methods are the function signature
* Instance methods are the each line of the pattern match
