module Hello exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

main : Html msg
main = div [] [header, content]

header : Html msg 
header = h1 [] [text "links"]

content : Html msg 
content = 
    ul [] [
        listItem "https://elm-lang.org" "homepg",
        listItem "https://package.elm-lang.org" "packages"
    ]

listItem : String -> String -> Html msg
listItem url text_ = li [] [a [href url] [text text_]]