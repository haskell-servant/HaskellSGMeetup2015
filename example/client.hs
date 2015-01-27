
import           Control.Monad.Trans.Either
import           Servant.Client
import           System.IO

import           Api


getHaskellPostings ::
  BaseUrl ->
  EitherT String IO (Listing RedditPost)
getHaskellPostings = client api


main :: IO ()
main = do
  let url = BaseUrl Http "localhost" 8000
  result <- runEitherT $ getHaskellPostings url
  case result of
    Right (Listing xs) ->
      mapM_ print xs
    Left error -> hPutStrLn stderr error
