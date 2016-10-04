module FindAddress.Rest exposing (..)

import FindAddress.Types exposing (..)
import Geometry exposing (LatLng)
import Http exposing (Error)
import Json.Decode as Json exposing (..)
import Json.Decode.Pipeline exposing (..)
import Task


decodeLocation : Decoder LatLng
decodeLocation =
    decode LatLng
        |> required "y" float
        |> required "x" float


decodeAttributes : Decoder Attributes
decodeAttributes =
    decode Attributes
        |> required "City" string


decodeCandidate : Decoder Candidate
decodeCandidate =
    decode Candidate
        |> required "address" string
        |> required "location" decodeLocation
        |> required "attributes" decodeAttributes
        |> required "score" float


decodeFindAddressCandidates : Decoder (List Candidate)
decodeFindAddressCandidates =
    "candidates" := list decodeCandidate


findCandidates : String -> Cmd (Result Error (List Candidate))
findCandidates term =
    "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
        ++ "?f=json&outFields=City&singleLine="
        ++ Http.uriEncode term
        |> Http.get decodeFindAddressCandidates
        |> Task.perform Err Ok
