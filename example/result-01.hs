{-# LANGUAGE DataKinds, DeriveGeneric, FlexibleInstances, TypeOperators #-}

module Main where


import           Control.Monad.IO.Class
import           Control.Monad.Trans.Either
import           Data.Aeson
import           Data.Maybe
import           GHC.Generics
import           Network.Wai
import           Network.Wai.Handler.Warp   as Warp
import           Servant
import           Servant.Client
import           Servant.Docs
import           System.IO

import           ApiDocs


main :: IO ()
main = Warp.run 8000 app

app :: Application
app = serve (Proxy :: Proxy Api) server

type Api =
       "person" :> QueryParam "name" String :> Get Person
  :<|> "person" :> Header "email" String :> ReqBody Person :> Post Person
  :<|> "api-docs" :> Raw

server :: Server Api
server =
       getPerson
  :<|> postPerson
  :<|> serveApiDocs (Proxy :: Proxy Api)


-- * business logic

data Person = Person { name :: String }
  deriving (Generic, Show)

instance ToJSON Person
instance FromJSON Person
instance ToSample Person where
  toSample = Just alice
instance ToParam (QueryParam "name" String) where
  toParam _ = DocQueryParam
    "name"
    ["alice", "peter"]
    "This is the name."
    Normal
instance ToSample () where
  toSample = Just ()

alice, bob :: Person
alice = Person "alice"
bob = Person "bob"

getPerson :: Maybe String -> EitherT (Int, String) IO Person
getPerson name = return $ Person $ fromMaybe "alice" name

postPerson :: Maybe String -> Person -> EitherT (Int, String) IO Person
postPerson mEmail person = do
  liftIO $ hPutStrLn stderr $ show (mEmail, person)
  return person


-- * Client

cGetPerson :: Maybe String -> BaseUrl -> EitherT String IO Person
(cGetPerson :<|> _) = client (Proxy :: Proxy Api)
