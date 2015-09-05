module View
  (rootView)
  where

import Util exposing (..)
import Geometry exposing (LatLng)
import Exts.Html.Bootstrap exposing (..)
import View.Compass exposing (compass)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import Schema exposing (..)
import FindAddress.View
import FindAddress.Schema

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div []
      [navbar uiChannel
      ,containerFluid [contentView uiChannel model]]

contentView : Address Action -> Model -> Html
contentView uiChannel model =
  div []
      [case model.view of
         FrontPage -> case model.findModel.chosenCandidate of
                        Nothing -> FindAddress.View.rootView (forwardTo uiChannel FindAction)
                                                             (case model.geolocation of
                                                                (Just (Ok position)) -> Just {latitude = position.coords.latitude
                                                                                             ,longitude = position.coords.latitude}
                                                                _ -> Nothing)
                                                             model.findModel
                        Just target -> frontPage uiChannel model]

navbar : Address Action -> Html
navbar uiChannel =
    nav [class "navbar navbar-default"]
        [containerFluid [div [class "navbar-header"]
                             [a [href "#"
                                ,class "navbar-brand"]
                                [text "Geo Hack Day"]]
                        ,ul [class "nav navbar-nav navbar-right"]
                            []]]

notFoundPage : Html
notFoundPage = row [div [class "col-md-8 col-md-offset-2"]
                     [div []
                          [h1 [] [text "404 Not Found"]]]]

frontPage : Address Action -> Model -> Html
frontPage uiChannel model =
  case (model.geolocation,model.orientation,model.findModel.chosenCandidate) of
    (Nothing,_,_) -> noPositionView
    (_,Nothing,_) -> noOrientationView
    (_,_,Nothing) -> noTargetView
    (Just (Err err),_,_) -> positionErrorView uiChannel err
    (_,Just (Err err),_) -> orientationErrorView err
    (Just (Ok position), Just (Ok orientation), Just candidate) -> div []
                                                                       [compass candidate.location position orientation
                                                                       ,button [class "btn btn-lg btn-block btn-primary"
                                                                               ,onClick uiChannel (FindAction FindAddress.Schema.Reset)]
                                                                               [text "Finish"]]
    _ -> debuggingView model

debuggingView : Model -> Html
debuggingView model =
  div []
      [h1 [] [text "TODO"]
      ,div []
           [code []
                 [text (toString model)]]]

positionView : LatLng -> Position -> Orientation -> Html
positionView target position orientation =
  let distance = distanceBetween position.coords target
      roundedDistance = roundTo 2 distance
      bearing = bearingTo position.coords target
      aim alpha = bearing - (round alpha)
      maybeAim = Maybe.map aim orientation.alpha
  in div [class "row"]
         [div [class "col-xs-12"]
              [compass target position orientation
              ,h3 [] [text ("Distance: " ++ toString roundedDistance ++ "km")]
              ,h3 [] [text ("Bearing: " ++ toString bearing ++ " degrees")]
              ,h3 [] [text ("Alpha: " ++ toString orientation.alpha ++ " degrees")]
              ,h3 [] [text ("Aim: " ++ toString maybeAim ++ " degrees")]
              ,orientationTable orientation
              ,positionTable position]]

orientationTable : Orientation -> Html
orientationTable orientation =
  table [class "table table-condensed table-bordered"]
        [thead [] []
        ,tbody []
               [tr []
                   [th [] [text "Alpha"]
                   ,td [] [text (toString orientation.alpha)]]
               ,tr []
                   [th [] [text "Beta"]
                   ,td [] [text (toString orientation.beta)]]
               ,tr []
                   [th [] [text "Gamma"]
                   ,td [] [text (toString orientation.gamma)]]]]

positionTable : Position -> Html
positionTable position =
  table [class "table table-condensed table-bordered"]
        [thead [] []
        ,tbody []
               [tr []
                   [th [] [text "Latitude"]
                   ,td [] [text (toString position.coords.latitude)]]
               ,tr []
                   [th [] [text "Longitude"]
                   ,td [] [text (toString position.coords.longitude)]]
               ,tr []
                   [th [] [text "Timestamp"]
                   ,td [] [text (toString position.timestamp)]]]]

noPositionView : Html
noPositionView = h2 [] [text "Awaiting location..."]

noTargetView : Html
noTargetView = h2 [] [text "Error - no target found."]

noOrientationView : Html
noOrientationView = h2 [] [text "Awaiting orientation..."]

orientationErrorView : String -> Html
orientationErrorView err =
  div [class "alert alert-warning"]
      [text err]

positionErrorView : Address Action -> PositionError -> Html
positionErrorView uiChannel err =
  div [class "alert alert-warning"]
      [text "Your position is not available. Please check your device settings."]
