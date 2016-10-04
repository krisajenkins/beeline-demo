module FindAddress.View exposing (..)

import Exts.Float exposing (roundTo)
import Exts.Html.Bootstrap as Bootstrap exposing (Ratio(SixteenByNine))
import Exts.Html.Events exposing (onEnter)
import Exts.LatLng exposing (distanceBetween)
import FindAddress.Schema exposing (..)
import Geometry exposing (LatLng)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


------------------------------------------------------------
-- Events
------------------------------------------------------------


rootView : Maybe LatLng -> Model -> Html Action
rootView currentLocation model =
    div []
        [ h3 [] [ text "Search for a destination" ]
        , searchForm model
        , case model.candidates of
            Nothing ->
                span [] []

            Just (Err err) ->
                div [ class "alert alert-danger" ] [ text <| toString err ]

            Just (Ok []) ->
                emptyResultsList

            Just (Ok xs) ->
                resultsList currentLocation xs
        , hr [] []
        , video
        ]


searchForm : Model -> Html Action
searchForm model =
    (div [ class "form-group" ]
        [ input
            [ class "form-control"
            , autofocus True
            , onEnter Submit
            , onInput (TermChange)
            , type' "text"
            ]
            []
        , hr [] []
        , button
            [ class "btn btn-lg btn-block btn-success"
            , disabled model.loading
            , type' "submit"
            , onClick Submit
            ]
            [ text "Search" ]
        ]
    )


emptyResultsList : Html msg
emptyResultsList =
    div [ class "alert alert-warning" ]
        [ text "No results found." ]


resultsList : Maybe LatLng -> List Candidate -> Html Action
resultsList currentLocation candidates =
    ul [ class "list-group" ]
        (List.map (resultItem currentLocation)
            (List.sortBy .score candidates)
        )


resultItem : Maybe LatLng -> Candidate -> Html Action
resultItem currentLocation candidate =
    let
        formattedDistance =
            case currentLocation of
                Nothing ->
                    ""

                Just location ->
                    toString (roundTo 2 (distanceBetween location candidate.location)) ++ "km"
    in
        li
            [ class "list-group-item"
            , onClick (ChooseCandidate candidate)
            ]
            [ text (candidate.address ++ " " ++ candidate.attributes.city) ]


video : Html msg
video =
    Bootstrap.video SixteenByNine "https://www.youtube.com/embed/pNguieZ4cTc"
