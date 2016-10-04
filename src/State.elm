module State exposing (..)

import FindAddress.State as FindAddress
import Ports
import Types exposing (..)


init : ( Model, Cmd Action )
init =
    let
        ( findModel, findCmd ) =
            FindAddress.init
    in
        ( { orientation = Nothing
          , findModel = findModel
          , geolocation = Nothing
          }
        , Cmd.map FindAction findCmd
        )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        ChangeLocation l ->
            ( { model | geolocation = l }, Cmd.none )

        ChangeOrientation o ->
            ( { model | orientation = o }, Cmd.none )

        FindAction a ->
            let
                ( newFindModel, newFindCmd ) =
                    FindAddress.update a model.findModel
            in
                ( { model | findModel = newFindModel }
                , Cmd.map FindAction newFindCmd
                )


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.batch
        [ Ports.orientation (Maybe.map Ok >> ChangeOrientation)
        , Ports.orientationError (Maybe.map Err >> ChangeOrientation)
        , Ports.geolocation (Maybe.map Ok >> ChangeLocation)
        , Ports.geolocationError (Maybe.map Err >> ChangeLocation)
        ]
