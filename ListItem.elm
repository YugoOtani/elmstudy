module ListItem exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model = {
    input : String,
    items : List {
        check : Bool,
        cont : String
    } }


init : Model
init = 
    {
        input = "",
        items = []
    }

type Msg = Input String | Submit | Check String | Del

update : Msg -> Model -> Model
update msg model = case msg of
    Input s -> { model |  input = s}
    Submit -> {input = "", items = {check = False, cont = model.input}::model.items}
    Check s -> { 
                input = model.input,
                items = List.map (\l -> {
                    cont = l.cont, 
                    check = if s==l.cont then not l.check else l.check
                }) model.items }
    Del -> {input = model.input, items = List.filter (\itm -> not itm.check) model.items}

view : Model -> Html Msg
view model =
    div [] [ 
            Html.form [onSubmit Submit] [
                input [value model.input, onInput Input] [],
                button [disabled (String.length model.input < 1)] [text "Submit"] 
            ],
            div [] (List.map viewItem model.items), 
            button [onClick Del] [text "Delete"]
    ]

viewItem item = div [] [
    input [
        type_ "checkbox", 
        onClick (Check item.cont), 
        checked item.check ] [],
    text item.cont]
