module Main where

import Effects exposing (Effects,Never,none,batch)
import Html exposing (Html)
import Result exposing (fromMaybe)
import Signal exposing (Signal, Mailbox, foldp, mergeMany, (<~), constant)
import StartApp exposing (App)
import Schema exposing (..)
import Task exposing (Task)
import View exposing (..)
import Schema

------------------------------------------------------------
-- View Tracking
------------------------------------------------------------
port uriHashSignal : Signal String

decodeHash : String -> View
decodeHash x =
  if | x == "" -> FrontPage
     | otherwise -> NotFoundPage

------------------------------------------------------------
-- Geolocation
------------------------------------------------------------
port geolocationSignal : Signal (Maybe Position)
port geolocationErrorSignal : Signal (Maybe PositionError)

------------------------------------------------------------
-- Dashboard Data
------------------------------------------------------------
asEffect : Task e a -> Effects (Result e a)
asEffect = Effects.task << Task.toResult

------------------------------------------------------------
-- Event stream.
------------------------------------------------------------
init : (Model, Effects Action)
init =
  ({view = FrontPage
   ,geolocation = Nothing}
  ,Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, none)
    ChangeView v -> ({model | view <- v}, none)
    ChangeLocation l -> ({model | geolocation <- l}, none)

app : App Model
app = StartApp.start {init = init
                     ,view = rootView
                     ,update = update
                     ,inputs = [ChangeView << decodeHash <~ uriHashSignal
                               ,ChangeLocation << Maybe.map Ok <~ geolocationSignal
                               ,ChangeLocation << Maybe.map Err <~ geolocationErrorSignal]}

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks
