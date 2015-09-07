module FindAddress.View where

import FindAddress.Schema exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import Exts.Html.Bootstrap as Bootstrap exposing (Ratio(SixteenByNine))
import Exts.Html.Events exposing (onEnter)
import Geometry exposing (LatLng)
import Exts.Float exposing (roundTo)
import Exts.LatLng exposing (distanceBetween)

------------------------------------------------------------
-- Events
------------------------------------------------------------
rootView : Address Action -> Maybe LatLng -> Model -> Html
rootView uiChannel currentLocation model =
  div []
      [h3 [] [text "Search for a destination"]
      ,searchForm uiChannel model
      ,case model.candidates of
        Nothing -> span [] []
        Just (Err err) -> div [class "alert alert-danger"] [text <| toString err]
        Just (Ok xs) -> resultsList uiChannel currentLocation xs
      ,hr [] []
      ,video]

searchForm : Address Action -> Model -> Html
searchForm uiChannel model =
  (div [class "form-group"]
       [input [class "form-control"
              ,autofocus True
              ,onEnter (message uiChannel Submit)
              ,on "keyup" targetValue (message (forwardTo uiChannel TermChange))
              ,type' "text"] []
       ,hr [] []
       ,button [class "btn btn-lg btn-block btn-success"
               ,disabled model.loading
               ,type' "submit"
               ,onClick uiChannel Submit]
               [text "Search"]])

resultsList : Address Action -> Maybe LatLng -> List Candidate -> Html
resultsList uiChannel currentLocation candidates =
  ul [class "list-group"]
     (List.map (resultItem uiChannel currentLocation)
               (List.sortBy .score candidates))

resultItem : Address Action -> Maybe LatLng -> Candidate -> Html
resultItem uiChannel currentLocation candidate =
  let formattedDistance =
    case currentLocation of
      Nothing -> ""
      Just location -> toString (roundTo 2 (distanceBetween location candidate.location)) ++ "km"
  in li [class "list-group-item"
        ,onClick uiChannel (ChooseCandidate candidate)]
        [text (candidate.address ++ " " ++ candidate.attributes.city)]

video : Html
video = Bootstrap.video SixteenByNine "https://www.youtube.com/embed/pNguieZ4cTc"
