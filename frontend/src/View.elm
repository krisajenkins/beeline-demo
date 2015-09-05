module View
  (rootView)
  where

import Exts.Html.Bootstrap exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (..)
import Schema exposing (..)

rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div []
      [navbar uiChannel
      ,containerFluid [contentView uiChannel model]]

contentView : Address Action -> Model -> Html
contentView uiChannel model =
  div []
      [case model.view of
         FrontPage -> frontPage uiChannel model]

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
  case model.geolocation of
    Nothing -> noPositionView
    Just (Ok position) -> positionView position
    Just (Err err) -> positionErrorView uiChannel err
    _ -> div []
             [h1 [] [text "TODO"]
             ,div []
                  [code []
                        [text (toString model)]]]

positionView : Position -> Html
positionView position =
  div [class "row"]
      [div [class "col-xs-12 col-sm-4 col-sm-offset-2"]
           [positionTable position]]

positionTable : Position -> Html
positionTable position =
  table [class "table table-condensed table-bordered"]
        [thead []
               [tr []
                   [th [] [text "Latitude"]
                   ,th [] [text "Longitude"]]]
        ,tbody []
               [tr []
                   [td [] [text (toString position.coords.latitude)]
                   ,td [] [text (toString position.coords.longitude)]]]]


noPositionView : Html
noPositionView = h2 [] [text "Awaiting location..."]

positionErrorView : Address Action -> PositionError -> Html
positionErrorView uiChannel err =
  div [class "alert alert-warning"]
      (case err.code of
         1 -> [text "To use this app, you must grant access to your location. Please check your devce settings.."
              ,button [class "btn btn-primary"
                      ,onClick uiChannel RequestLocation]
                      [text "Grant Access"]]
         2 -> [text "Your position is not available. Please check your device settings."]
         3 -> [text "Your position is not available. Please check your device settings."]
         _ -> [text err.message])
