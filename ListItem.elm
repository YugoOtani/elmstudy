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
type alias Item = String
type alias Box = {check : Bool, item : Item }
type alias Model = {input : String, boxs : List Box }

init : Model
init = 
    {
        input = "",
        boxs = []
    }

type Msg = Input String | Submit | Check String | Del

update : Msg -> Model -> Model
update msg model = case msg of
    Input s -> { model |  input = s}
    Submit -> {input = "", boxs = (newBox model.input) :: model.boxs}
    Check s -> { model | boxs = List.map (\b -> if s == b.item then checkBox b else b)  model.boxs }
    Del -> {input = model.input, boxs = List.filter (\bx -> not bx.check) model.boxs}

view : Model -> Html Msg
view model =
    div [] [ 
            Html.form [onSubmit Submit] [
                input [value model.input, onInput Input] [],
                button [disabled (String.length model.input < 1)] [text "Submit"] 
            ],
            div [] (List.map viewBox model.boxs), 
            button [onClick Del] [text "Delete"]
    ]

viewBox box = div [] [
    input [
        type_ "checkbox", 
        onClick (Check box.item), 
        checked box.check ] [],
    text box.item]

newBox : Item -> Box
newBox itm = {check = False, item = itm}

checkBox : Box -> Box
checkBox bx = {bx | check = not bx.check}
