{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
module AuthenticationCombinator where

import Servant
import Network.Wai
import Network.HTTP.Types

-- The combinator
data WithAuthentication = WithAuthentication

type DBLookup = String -> IO Bool

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
    route Proxy (WithAuthentication :> a) request{..} respond =
        case lookup "Cookie" requestHeader of
            Nothing -> responseLBS status401 [] ""
            Just x  -> if isGoodCookie x
                   then route (Proxy :: Proxy a) request response
                   else responseLBS status403 [] ""
