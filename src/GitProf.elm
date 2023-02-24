module GitProf exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (string)
import Json.Decode.Pipeline exposing (required)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
type alias Model = {input : String, result : String}
type Msg = Search | GotRepo (Result Http.Error String) | Input String

init : () -> (Model, Cmd Msg)
init _ = ({input = "", result = ""}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        Search -> (model, Http.get{
            url = "http://api.github.com/users/" ++ model.input
            , expect = Http.expectString GotRepo
            })
        Input s -> ({model | input = s},Cmd.none)
        GotRepo (Ok repo) -> ({model | result = repo}, Cmd.none)
        GotRepo (Err err) -> ({model | result = Debug.toString err}, Cmd.none)

view : Model -> Html Msg
view model = div []
    [
    Html.form [onSubmit Search] 
            [
                input [value model.input, onInput Input] [],
                button [disabled (String.length model.input < 1)] [text "Search"] 
            ]
    ,p [] [text model.result]
    ]

