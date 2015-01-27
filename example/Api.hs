{-# LANGUAGE DataKinds, DeriveGeneric, OverloadedStrings, TypeOperators,
             ViewPatterns #-}


module Api where


import           Control.Applicative
import           Data.Aeson              hiding (Result)
import           Data.List
import           Data.String.Conversions
import           GHC.Generics

import           Servant


type Api =
  "r" :> Capture "subreddit" SubReddit :> QueryParam "limit" Int :> Get (Listing RedditPost)

api :: Proxy Api
api = Proxy


data SubReddit = SubReddit String

instance ToText SubReddit where
  toText (SubReddit s) = cs (s ++ ".json")

instance FromText SubReddit where
  fromText (cs -> s) = if ".json" `isSuffixOf` s
    then Just $ SubReddit $ reverse $ drop 5 $ reverse s
    else Nothing

data Listing a = Listing [a]
  deriving (Show)

instance FromJSON a => FromJSON (Listing a) where
  parseJSON (Object o) = do
    children <- (o .: "data") >>= (.: "children")
    let parseChild (Object o) = o .: "data"
        parseChild _ = fail "not an object"
    Listing <$> mapM parseChild children
  parseJSON _ = fail "not an object"

instance ToJSON a => ToJSON (Listing a) where
  toJSON (Listing xs) =
    let toChild x = object ["data" .= toJSON x]
    in object ["data" .= (object ["children" .= map toChild xs])]


data RedditPost = RedditPost {
  title :: String,
  url :: String
 }
  deriving (Show, Generic)

instance FromJSON RedditPost
instance ToJSON RedditPost
