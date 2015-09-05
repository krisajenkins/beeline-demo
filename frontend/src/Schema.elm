module Schema where

import Native.Schema
import Task exposing (..)

type View
  = NotFoundPage
  | FrontPage

type alias Coordinates =
  {accuracy : Float
  ,altitude : Maybe Float
  ,altitudeAccuracy : Maybe Float
  ,heading : Maybe Float
  ,latitude : Float
  ,longitude : Float
  ,speed : Maybe Float}

type alias Position =
  {coords : Coordinates
  ,timestamp : Float}

type alias PositionError =
  {code : Int
  ,message : String}


type alias Model =
  {view : View
  ,geolocation : Maybe (Result PositionError Position)}

type Action
  = NoOp
  | ChangeView View
  | ChangeLocation (Maybe (Result PositionError Position))
  | RequestLocation

requestLocation : Task PositionError Position
requestLocation = Native.Schema.requestLocation
