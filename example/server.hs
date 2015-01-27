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
app = serve api server

server :: Server Api
server = getHaskellPosts

getHaskellPosts :: EitherT (Int, String) IO (Listing RedditPost)
getHaskellPosts =
  return $ Listing $ take 10 $ repeat $
    RedditPost "foo" "bar.com"
