module FindAddress.Schema exposing (..)

import Json.Decode as Json exposing (..)
import Json.Decode.Pipeline exposing (..)
import Http exposing (Error)
import Geometry exposing (LatLng)


type alias Attributes =
    { city : String }


type alias Candidate =
    { address : String
    , location : LatLng
    , attributes : Attributes
    , score : Float
    }


type alias Model =
    { term : Maybe String
    , loading : Bool
    , chosenCandidate : Maybe Candidate
    , candidates : Maybe (Result Error (List Candidate))
    }


type Action
    = TermChange String
    | Submit
    | SearchCandidates (Result Error (List Candidate))
    | ChooseCandidate Candidate
    | Reset


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
