module FindAddress.Main where

import Task
import Exts.Effects exposing (noFx)
import Http exposing (Error)
import FindAddress.Schema exposing (..)
import Effects exposing (Effects,none,Never)

init : (Model, Effects Action)
init = noFx
  {term = Nothing
  ,loading = False
  ,chosenCandidate = Nothing
  ,candidates = Nothing}

findCandidates : String -> Effects (Result Error (List Candidate))
findCandidates term =
  "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
    ++ "?f=json&outFields=City&singleLine=" ++ Http.uriEncode term
  |> Http.get decodeFindAddressCandidates
  |> Task.toResult
  |> Effects.task

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Submit -> ({model | loading <- True}
              , case model.term of
                  Nothing -> none
                  Just term -> Effects.map SearchCandidates (findCandidates term))
    TermChange t -> noFx {model | term <- Just t}
    SearchCandidates xs -> noFx {model | candidates <- Just xs
                                       , loading <- False}
    ChooseCandidate x -> noFx {model | chosenCandidate <- Just x}
    Reset -> init
