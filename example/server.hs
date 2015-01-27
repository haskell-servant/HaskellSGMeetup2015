
module Main where


import           Network.Wai
import           Network.Wai.Handler.Warp as Warp


main :: IO ()
main = Warp.run 8000 app

app :: Application
app = undefined


-- * business logic

data Person = Person { name :: String }

alice :: Person
alice = Person "alice"
bob = Person "bob"
