{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module AuthenticationCombinator where

import Servant
import Servant.Server.Internal ( succeedWith )
import Data.ByteString
import Network.Wai
import Network.Wai.Handler.Warp ( run )
import Network.HTTP.Types

-- The combinator
data WithAuthentication = WithAuthentication

type DBLookup = ByteString -> IO Bool

isGoodCookie :: DBLookup
isGoodCookie = return . (== "myHardcodedCookie")

-- The server instance
--
-- For reference:
--
-- > class HasServer layout where
-- >   type Server layout :: *
-- >   route :: Proxy layout -> Server layout -> RoutingApplication
instance forall a. HasServer a => HasServer (WithAuthentication :> a) where
    -- The type of the endpoints remains the same
    type Server (WithAuthentication :> a) = Server a

    -- Here we add the functionality.
    route Proxy a request respond =
        case lookup "Cookie" (requestHeaders request) of
            Nothing -> respond $ succeedWith $ responseLBS status401 [] ""
            Just x  -> do
                cookie <- isGoodCookie x
                if cookie
                   then route (Proxy :: Proxy a) a request respond
                   else respond $ succeedWith $ responseLBS status403 [] ""


-- Now let's use it!

type MyApi = "home" :> Get Int
        :<|> "secret" :> SecretApi

type SecretApi = WithAuthentication :> ( "name" :> Get String
                                    :<|> "age"  :> Get Int )

myApi :: Proxy MyApi
myApi = Proxy

secretServer :: Server SecretApi
secretServer = getName :<|> getAge
    where getName = return "Dread Pirate Roberts"
          getAge  = return 572

server :: Server MyApi
server = getHome
    :<|> secretServer
  where getHome = return 5

main :: IO ()
main = run 8090 (serve myApi server)
