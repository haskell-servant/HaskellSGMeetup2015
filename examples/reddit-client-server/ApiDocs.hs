{-# LANGUAGE OverloadedStrings #-}

module ApiDocs where


import           Control.Exception
import           Control.Monad
import           Data.String.Conversions
import           Network.HTTP.Types
import           Network.Wai
import           Servant
import           Servant.Docs
import           System.Exit
import           System.Process


serveApiDocs :: HasDocs api => Proxy api -> Application
serveApiDocs api request respond = do
  html <- readProcess "pandoc" [] (markdown $ docs api)
--  when (exitCode /= ExitSuccess) $
--    throwIO (ErrorCall ("pandoc exited with: " ++ show exitCode))
  respond $ responseLBS ok200 [("Content-Type", "text/html")] (cs html)
