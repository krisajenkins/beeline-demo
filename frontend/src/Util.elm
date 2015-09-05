module Util
  (resultMappend
  ,maybeMappend)
  where

maybeMappend : Maybe a -> Maybe b -> Maybe (a,b)
maybeMappend a b =
  case (a,b) of
    (Nothing,_) -> Nothing
    (_,Nothing) -> Nothing
    (Just x, Just y) -> Just (x,y)

resultMappend : Result e a -> Result e b -> Result e (a,b)
resultMappend a b =
  case (a,b) of
    (Err x,_) -> Err x
    (_,Err y) -> Err y
    (Ok x, Ok y) -> Ok (x,y)
