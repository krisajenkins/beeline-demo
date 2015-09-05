module FindAddress.Schema where

import Json.Decode as Json exposing (..)
import Json.Decode.Extra exposing (apply,date)
import Http exposing (Error)
import Geometry exposing (LatLng)

type alias Candidate =
  {address: String
  ,location: LatLng
  ,score : Float}

type alias Model =
  {term : Maybe String
  ,loading : Bool
  ,chosenCandidate : Maybe Candidate
  ,candidates : Maybe (Result Error (List Candidate))}

type Action
  = NoOp
  | TermChange String
  | Submit
  | SearchCandidates (Result Error (List Candidate))
  | ChooseCandidate Candidate
  | Reset

decodeLocation : Decoder LatLng
decodeLocation = LatLng
  `map`   ("y" := float)
  `apply` ("x" := float)

decodeCandidate : Decoder Candidate
decodeCandidate = Candidate
  `map`   ("address" := string)
  `apply` ("location" := decodeLocation)
  `apply` ("score" := float)

decodeFindAddressCandidates : Decoder (List Candidate)
decodeFindAddressCandidates =
  at ["candidates"] (list decodeCandidate)
