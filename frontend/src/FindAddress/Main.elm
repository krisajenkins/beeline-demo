module FindAddress.Main where

import Task
import Http exposing (Error)
import FindAddress.Schema exposing (..)
import Effects exposing (Effects,none,Never)

init : (Model, Effects Action)
init =
  ({term = Nothing
   ,chosenCandidate = Nothing
   ,candidates = Nothing}
   ,none)

findCandidates : String -> Effects (Result Error (List Candidate))
findCandidates term = Effects.task (Task.toResult (Http.get decodeFindAddressCandidates ("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates?f=json&singleLine=" ++ term)))

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, none)
    Submit -> (model, case model.term of
                        Nothing -> none
                        Just term -> Effects.map SearchCandidates (findCandidates term))
    TermChange t -> ({model | term <- Just t}, none)
    SearchCandidates xs -> ({model | candidates <- Just xs}, none)
    ChooseCandidate x -> ({model | chosenCandidate <- Just x}, none)
    ClearChoice -> ({model | chosenCandidate <- Nothing}, none)
