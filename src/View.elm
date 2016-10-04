module View exposing (rootView)

import Exts.Html.Bootstrap exposing (..)
import FindAddress.Schema
import FindAddress.View
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Schema exposing (..)
import View.Compass exposing (compass)


rootView : Model -> Html Action
rootView model =
    div []
        [ node "link"
            [ href "bootstrap-3.3.4/css/bootstrap.min.css"
            , rel "stylesheet"
            ]
            []
        , node "link"
            [ href "style.css"
            , type' "text/css"
            , rel "stylesheet"
            ]
            []
        , node "meta"
            [ charset "UTF-8.css" ]
            []
        , node "meta"
            [ name "viewport"
            , content "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui"
            ]
            []
        , navbar
        , containerFluid
            [ div [ class "row" ]
                [ div
                    [ classList
                        [ ( "col-xs-12", True )
                        , ( "col-sm-8 col-sm-offset-2", True )
                        , ( "col-md-6 col-md-offset-3", True )
                        , ( "col-lg-4 col-lg-offset-4", True )
                        ]
                    ]
                    [ contentView model ]
                ]
            ]
        ]


contentView : Model -> Html Action
contentView model =
    div []
        [ case model.findModel.chosenCandidate of
            Nothing ->
                Html.map FindAction
                    <| FindAddress.View.rootView
                        (case model.geolocation of
                            Just (Ok position) ->
                                Just
                                    { latitude = position.coords.latitude
                                    , longitude = position.coords.longitude
                                    }

                            _ ->
                                Nothing
                        )
                        model.findModel

            Just target ->
                frontPage model
        ]


navbar : Html msg
navbar =
    nav [ class "navbar navbar-default" ]
        [ containerFluid
            [ div [ class "navbar-header" ]
                [ a
                    [ href "#"
                    , class "navbar-brand"
                    ]
                    [ text "Find My Way" ]
                ]
            , ul [ class "nav navbar-nav navbar-right" ]
                []
            ]
        ]


frontPage : Model -> Html Action
frontPage model =
    case ( model.geolocation, model.orientation, model.findModel.chosenCandidate ) of
        ( Nothing, _, _ ) ->
            noPositionView

        ( _, Nothing, _ ) ->
            noOrientationView

        ( _, _, Nothing ) ->
            noTargetView

        ( Just (Err err), _, _ ) ->
            positionErrorView err

        ( _, Just (Err err), _ ) ->
            orientationErrorView err

        ( Just (Ok position), Just (Ok orientation), Just candidate ) ->
            div []
                [ compass candidate.location position orientation
                , button
                    [ class "btn btn-lg btn-block btn-primary"
                    , onClick (FindAction FindAddress.Schema.Reset)
                    ]
                    [ text "Finish" ]
                ]


noPositionView : Html msg
noPositionView =
    h2 [] [ text "Awaiting location..." ]


noTargetView : Html msg
noTargetView =
    h2 [] [ text "Error - no target found." ]


noOrientationView : Html msg
noOrientationView =
    h2 [] [ text "Awaiting orientation..." ]


orientationErrorView : String -> Html msg
orientationErrorView err =
    div [ class "alert alert-warning" ]
        [ text err ]


positionErrorView : PositionError -> Html msg
positionErrorView err =
    div [ class "alert alert-warning" ]
        [ p [] [ text "Your position is not available." ]
        , p [] [ text "iPhone: Settings -> Privacy -> Location Services -> Safari Websites -> While Using the App" ]
        , p [] [ text "Please check your device settings." ]
        ]
