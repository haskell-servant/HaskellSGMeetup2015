{-# LANGUAGE ViewPatterns #-}

module Main where


import           Control.Monad.Trans.Either
import           Data.Maybe
import           Network.Wai
import           Network.Wai.Handler.Warp   as Warp
import           Servant
import           Servant.Server

import           Api


main :: IO ()
main = Warp.run 8000 app

app :: Application
app = serve api (server :: Server Api)

server =
    getListings :<|> (
         getUserName
    :<|> return "baz")
  :<|> search

getListings :: Maybe Int -> EitherT (Int, String) IO (Listing RedditPost)
getListings (fromMaybe 10 -> limit) =
  return $ Listing $ take limit $ repeat (RedditPost "foo" "bar.com")

getUserName :: EitherT (Int, String) IO String
getUserName = left (403, "not allowed")

search :: Maybe String -> EitherT (Int, String) IO [String]
search x = return [show x]
