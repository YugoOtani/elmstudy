module Button exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Inc
    | Dec


update : Msg -> Model -> Model
update m =
    case m of
        Inc ->
            \x -> x + 1

        Dec ->
            \x -> x - 1


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Dec ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Inc ] [ text "+" ]
        ]
