module Main where

import Time exposing (every,millisecond)
import Effects exposing (Effects,Never,none,batch)
import Html exposing (Html)
import Result exposing (fromMaybe)
import Signal exposing (Signal, Mailbox, foldp, mergeMany, (<~), constant, sampleOn)
import StartApp exposing (App)
import Schema exposing (..)
import FindAddress.Main
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
-- Event stream.
------------------------------------------------------------
init : (Model, Effects Action)
init =
  let (findModel,findEffects) = FindAddress.Main.init
  in ({view = FrontPage
      ,orientation = Nothing
      ,findModel = findModel
      ,geolocation = Nothing}
     ,Effects.map FindAction findEffects)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, none)
    ChangeView v -> ({model | view <- v}, none)
    ChangeLocation l -> ({model | geolocation <- l}, none)
    ChangeOrientation o -> ({model | orientation <- o}, none)
    FindAction a -> let (newFindModel, newFindEffects) = FindAddress.Main.update a model.findModel
                    in ({model | findModel <- newFindModel}, Effects.map FindAction newFindEffects)

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
