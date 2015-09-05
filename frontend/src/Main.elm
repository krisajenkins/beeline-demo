module Main where

import Time exposing (every,millisecond)
import Effects exposing (Effects,Never,none,batch)
import Html exposing (Html)
import Result exposing (fromMaybe)
import Signal exposing (Signal, Mailbox, foldp, mergeMany, (<~), constant, sampleOn)
import StartApp exposing (App)
import Schema exposing (..)
import Task exposing (Task)
import View exposing (..)

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
port orientationSignal : Signal (Maybe Orientation)
port orientationErrorSignal : Signal (Maybe String)
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
  ,target = {latitude = 51.485167, longitude = -0.271801} -- Chiswick
 -- ,target = {latitude = -25.487333, longitude = 137.422671} -- Australia
  --,target = {latitude = 51.460986, longitude = -0.064116} -- Peckham
  --,target = {latitude = 40.647067, longitude = -73.949289} -- NYC
  --,target = {latitude = 51.528182, longitude = -0.086533} -- OLD ST
   ,orientation = Nothing
   ,geolocation = Nothing}
  ,Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, none)
    ChangeView v -> ({model | view <- v}, none)
    ChangeLocation l -> ({model | geolocation <- l}, none)
    ChangeOrientation o -> ({model | orientation <- o}, none)

app : App Model
app = StartApp.start {init = init
                     ,view = rootView
                     ,update = update
                     ,inputs = [ChangeView << decodeHash <~ uriHashSignal
                               ,ChangeOrientation << Maybe.map Ok <~ sampleOn (every (100 * millisecond)) orientationSignal
                               ,ChangeOrientation << Maybe.map Err <~ orientationErrorSignal
                               ,ChangeLocation << Maybe.map Ok <~ geolocationSignal
                               ,ChangeLocation << Maybe.map Err <~ geolocationErrorSignal]}

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks
