module GitProf exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (required)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
type alias Model = {result : String}
type Msg = Search | GotRepo (Result Http.Error String) | Input String

init : () -> (Model, Cmd Msg)
init _ = ({result = ""}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        Search -> (model, Http.get{
            url = "http://api.github.com/repos/elm/core"
            , expect = Http.expectString GotRepo
            })
        GotRepo (Ok repo) -> ({model | result = repo}, Cmd.none)
        GotRepo (Err err) -> ({model | result = Debug.toString err}, Cmd.none)

view : Model -> Html Msg
view model = div [] 
    [button [onClick Click] [text "get rep info"]
    , p [] [text model.result]
    ]

