module Schema where

import FindAddress.Schema

type alias Orientation =
  {alpha : Maybe Float
  ,beta : Maybe Float
  ,gamma : Maybe Float}

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
  {findModel : FindAddress.Schema.Model
  ,orientation : Maybe (Result String Orientation)
  ,geolocation : Maybe (Result PositionError Position)}

type Action
  = NoOp
  | ChangeOrientation (Maybe (Result String Orientation))
  | ChangeLocation (Maybe (Result PositionError Position))
  | FindAction FindAddress.Schema.Action
