module Util where

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

------------------------------------------------------------

roundTo : Int -> Float -> Float
roundTo places =
  let factor = 10 ^ places
  in (*) factor >> round >> toFloat >> (\n -> n / factor)

distanceBetween : {a | latitude : Float, longitude : Float}
               -> {b | latitude : Float, longitude : Float}
               -> Float
distanceBetween a b =
  let earthRadius = 6371
      dlat = degrees ((b.latitude) - (a.latitude))
      dlng = degrees ((b.longitude) - (a.longitude))
      v1 = (sin (dlat / 2)) * (sin (dlat / 2))
          + cos (degrees (a.latitude)) * cos (degrees (b.latitude))
          * sin (dlng / 2) * sin (dlng / 2)
      v2 = 2 * (atan2 (sqrt v1) (sqrt (1 - v1)))
  in earthRadius * v2

bearingTo : {a | latitude : Float, longitude : Float}
         -> {b | latitude : Float, longitude : Float}
         -> Int
bearingTo a b =
  let dlon = ((degrees b.longitude) - (degrees a.longitude))
      y = (sin dlon) * (cos (degrees b.latitude))
      x = ((cos (degrees a.latitude)) * (sin (degrees b.latitude))) - ((sin (degrees a.latitude)) * (cos (degrees b.latitude)) * (cos dlon))
      bearing = (atan2 y x) * (180 / pi)
  in (round bearing + 360) % 360
