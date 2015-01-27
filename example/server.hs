{-# LANGUAGE ViewPatterns #-}

module Main where


import           Control.Monad.Trans.Either
import           Data.Maybe
import           Network.Wai
import           Network.Wai.Handler.Warp   as Warp
import           Servant.Server

import           Api


main :: IO ()
main = Warp.run 8000 app

app :: Application
app = serve api (server :: Server Api)

server =
  getListings

getListings :: SubReddit -> Maybe Int -> EitherT (Int, String) IO (Listing RedditPost)
getListings subreddit (fromMaybe 10 -> limit) =
  return $ Listing $ take limit $ repeat (RedditPost "foo" "bar.com")
