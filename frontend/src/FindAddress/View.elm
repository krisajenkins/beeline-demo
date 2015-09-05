module FindAddress.View where

import FindAddress.Schema exposing (..)
import Json.Decode as Json
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)

------------------------------------------------------------
-- Events
------------------------------------------------------------
keyCodeIs : Int -> Int -> Result String ()
keyCodeIs expected actual =
  if expected == actual then Ok () else Err "Not the right key code"

enterKey : Int -> Result String ()
enterKey = keyCodeIs 13

onEnter : Message -> Attribute
onEnter message =
    on "keydown"
      (Json.customDecoder keyCode enterKey)
      (always message)


rootView : Address Action -> Model -> Html
rootView uiChannel model =
  div []
      [h3 [] [text "Search for a destination"]
      ,searchForm uiChannel model
      ,case model.candidates of
        Nothing -> span [] []
        Just (Err err) -> div [class "alert alert-danger"] [text <| toString err]
        Just (Ok xs) -> resultsList uiChannel xs]

searchForm : Address Action -> Model -> Html
searchForm uiChannel model =
  Html.form []
            [div [class "form-group"]
                 [input [class "form-control"
                        ,autofocus True
                        ,onEnter (message uiChannel Submit)
                        ,on "keyup" targetValue (message (forwardTo uiChannel TermChange))
                        ,type' "text"] []
                 ,button [class "btn btn-block btn-success"
                         ,type' "button"
                         ,onClick uiChannel Submit]
                         [text "Search"]]]

resultsList : Address Action -> List Candidate -> Html
resultsList uiChannel candidates =
  ul [class "list-group"]
     (List.map (resultItem uiChannel) (List.sortBy .score candidates))

resultItem : Address Action -> Candidate -> Html
resultItem uiChannel candidate =
  li [class "list-group-item"
     ,onClick uiChannel (ChooseCandidate candidate)]
     [text candidate.address]
