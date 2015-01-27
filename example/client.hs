
module Main where


import           Control.Monad.Trans.Either
import           Data.Foldable
import           Servant.Client

import           Api


main :: IO ()
main = do
  let url = BaseUrl Http "localhost" 8000
  result <- runEitherT (getPostings (Just 3) url)
  case result of
    Right (Listing postings) -> forM_ postings print

getPostings :: Maybe Int -> BaseUrl -> EitherT String IO (Listing RedditPost)
getPostings = client api
