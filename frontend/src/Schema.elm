module Schema where

type View
  = NotFoundPage
  | FrontPage

type alias LatLng =
  {latitude : Float
  ,longitude : Float}

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
  {view : View
  ,target : LatLng
  ,orientation : Maybe (Result String Orientation)
  ,geolocation : Maybe (Result PositionError Position)}

type Action
  = NoOp
  | ChangeView View
  | ChangeOrientation (Maybe (Result String Orientation))
  | ChangeLocation (Maybe (Result PositionError Position))

roundTo : Int -> Float -> Float
roundTo places =
  let factor = 10 ^ places
  in (*) factor >> round >> toFloat >> (\n -> n / factor)

distanceBetween : {a | latitude : Float, longitude : Float}
               -> {b | latitude : Float, longitude : Float}
               -> Float
distanceBetween a b =
  let earthRadius = 6371
      dlat = degrees ((b.latitude) - (a.latitude))
      dlng = degrees ((b.longitude) - (a.longitude))
      v1 = (sin (dlat / 2)) * (sin (dlat / 2))
          + cos (degrees (a.latitude)) * cos (degrees (b.latitude))
          * sin (dlng / 2) * sin (dlng / 2)
      v2 = 2 * (atan2 (sqrt v1) (sqrt (1 - v1)))
  in earthRadius * v2

bearingTo : {a | latitude : Float, longitude : Float}
         -> {b | latitude : Float, longitude : Float}
         -> Int
bearingTo a b =
  let dlon = ((degrees b.longitude) - (degrees a.longitude))
      y = (sin dlon) * (cos (degrees b.latitude))
      x = ((cos (degrees a.latitude)) * (sin (degrees b.latitude))) - ((sin (degrees a.latitude)) * (cos (degrees b.latitude)) * (cos dlon))
      bearing = (atan2 y x) * (180 / pi)
  in (round bearing + 360) % 360
