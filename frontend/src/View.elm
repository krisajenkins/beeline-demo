module View
  (rootView)
  where

import Exts.Html.Bootstrap exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
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
         FrontPage -> frontPage model]

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

frontPage : Model -> Html
frontPage model =
  case model.geolocation of
    Nothing -> noPositionView
    Just (Ok position) -> positionView position
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
