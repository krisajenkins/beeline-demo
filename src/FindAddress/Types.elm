module FindAddress.Types exposing (..)

import Geometry exposing (LatLng)
import Http exposing (Error)


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
