{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
module AuthenticationCombinator where

import Data.ByteString
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp ( run )
import Servant
import Servant.Server.Internal ( succeedWith )



-- A stand-in function for whatever you'd actually do to check the cookie
isGoodCookie :: ByteString -> IO Bool
isGoodCookie = return . (== "myHardcodedCookie")

--------------------------------------------------------------------------
-- First, write the combinator


--------------------------------------------------------------------------
-- Second, write the instance
-- For reference:
--
-- > class HasServer layout where
-- >   type Server layout :: *
-- >   route :: Proxy layout -> Server layout -> RoutingApplication


--------------------------------------------------------------------------
-- Finally, write a simple server to try things out
