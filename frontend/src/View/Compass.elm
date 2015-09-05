module View.Compass where

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Schema exposing (..)
import Html exposing (Html)

compass : LatLng -> Position -> Orientation -> Html
compass target position orientation =
  let distance = distanceBetween position.coords target
      roundedDistance = roundTo 2 distance
      bearing = bearingTo position.coords target
      aim alpha = bearing - (round alpha)
      maybeAim = Maybe.map aim orientation.alpha
      transformString = case maybeAim of
                          Nothing -> ""
                          Just b -> "rotate(" ++ (toString (-b)) ++ " 60 60)"
  in svg [width "90vw", height "90vw", viewBox "0 0 120 120"]
         [circle [cx "60", cy "60", r "51", fill "none", stroke "grey", strokeWidth "5"]
                 []
         ,Svg.path [d "M 50 10 A 50 50 0 0 1 70 10", fill "none", stroke "red", strokeWidth "5", transform transformString]
                   []
         ,polygon [points "58,10 60,3 62,10", fill "red", stroke "red", strokeWidth "1", transform transformString] []

         ,text' [x "60", y "65", textAnchor "middle"]
                [text (toString roundedDistance ++ "km")]]
