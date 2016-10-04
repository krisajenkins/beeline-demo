port module Ports exposing (..)

import Schema exposing (..)


port orientation : (Maybe Orientation -> msg) -> Sub msg


port orientationError : (Maybe String -> msg) -> Sub msg


port geolocation : (Maybe Position -> msg) -> Sub msg


port geolocationError : (Maybe PositionError -> msg) -> Sub msg
