module View
  (rootView)
  where

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
      [node "link" [href "bootstrap-3.3.4/css/bootstrap.min.css"
                   ,rel "stylesheet"]
                   []
      ,node "link" [href "style.css"
                   ,type' "text/css"
                   ,rel "stylesheet"]
                   []
      ,node "meta" [charset "UTF-8.css"]
                   []
      ,node "meta" [name "viewport"
                   ,content "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui"]
                   []
      ,navbar uiChannel
      ,containerFluid [div [class "row"]
                           [div [class "col-xs-12
                                        col-sm-8 col-sm-offset-2
                                        col-md-6 col-md-offset-3
                                        col-lg-4 col-lg-offset-4"]
                                [contentView uiChannel model]]]]

contentView : Address Action -> Model -> Html
contentView uiChannel model =
  div []
      [case model.findModel.chosenCandidate of
         Nothing -> FindAddress.View.rootView (forwardTo uiChannel FindAction)
                                              (case model.geolocation of
                                                 (Just (Ok position)) -> Just {latitude = position.coords.latitude
                                                                              ,longitude = position.coords.longitude}
                                                 _ -> Nothing)
                                              model.findModel
         Just target -> frontPage uiChannel model]

navbar : Address Action -> Html
navbar uiChannel =
    nav [class "navbar navbar-default"]
        [containerFluid [div [class "navbar-header"]
                             [a [href "#"
                                ,class "navbar-brand"]
                                [text "Beeline"]]
                        ,ul [class "nav navbar-nav navbar-right"]
                            []]]

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
      [p [] [text "Your position is not available."]
      ,p [] [text "iPhone: Settings -> Privacy -> Location Services -> Safari Websites -> While Using the App"]
      ,p [] [text "Please check your device settings."]]
