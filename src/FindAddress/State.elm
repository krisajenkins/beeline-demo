module FindAddress.State exposing (..)

import FindAddress.Rest exposing (..)
import FindAddress.Types exposing (..)


init : ( Model, Cmd Action )
init =
    ( { term = Nothing
      , loading = False
      , chosenCandidate = Nothing
      , candidates = Nothing
      }
    , Cmd.none
    )


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
