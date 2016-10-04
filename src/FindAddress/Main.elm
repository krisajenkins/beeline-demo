module FindAddress.Main exposing (..)

import FindAddress.Schema exposing (..)
import Http exposing (Error)
import Task


init : ( Model, Cmd Action )
init =
    ( { term = Nothing
      , loading = False
      , chosenCandidate = Nothing
      , candidates = Nothing
      }
    , Cmd.none
    )


findCandidates : String -> Cmd (Result Error (List Candidate))
findCandidates term =
    "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/findAddressCandidates"
        ++ "?f=json&outFields=City&singleLine="
        ++ Http.uriEncode term
        |> Http.get decodeFindAddressCandidates
        |> Task.perform Err Ok


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Submit ->
            ( { model | loading = True }
            , case model.term of
                Nothing ->
                    Cmd.none

                Just term ->
                    Cmd.map SearchCandidates (findCandidates term)
            )

        TermChange t ->
            ( { model | term = Just t }, Cmd.none )

        SearchCandidates xs ->
            ( { model
                | candidates = Just xs
                , loading = False
              }
            , Cmd.none
            )

        ChooseCandidate x ->
            ( { model | chosenCandidate = Just x }, Cmd.none )

        Reset ->
            init
