module CustomEvent exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)

main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
type alias Model = {s : String }

init : Model
init = { s = "hello" }

type Msg = SomeMsg

update : Msg -> Model -> Model
update msg model = case msg of
        SomeMsg -> { s = "bye" }
    
view : Model -> Html Msg
view model =
    div [] 
    [ 
        button [(\m -> on "click" (succeed m)) SomeMsg] [text model.s]
    ]


