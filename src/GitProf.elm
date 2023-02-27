module GitProf exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D
import Json.Decode.Pipeline as P


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
type alias Model = {input : String, usr : User}
type Msg = Search | GotRepo (Result Http.Error User) | Input String
type alias User = 
    { login : String
    ,avator : String
    ,prof : String
    }   
emptyUser = { login = ""
            ,avator = ""
            ,prof   = ""
            }
init : () -> (Model, Cmd Msg)
init _ = ({input = "", usr = emptyUser}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        Search -> (model, Http.get{
            url = "http://api.github.com/users/" ++ model.input
            , expect = Http.expectJson GotRepo decodeUser
            })
        Input s -> ({model | input = s},Cmd.none)
        GotRepo (Ok repo) -> ({model | usr = repo}, Cmd.none)
        GotRepo (Err err) -> ({model | usr = emptyUser}, Cmd.none)

view : Model -> Html Msg
view model = div [] 
    [Html.form [onSubmit Search] [viewInput model, viewButton model]
    ,p [] [text (Debug.toString model.usr)]
    ]
viewInput model = input [value model.input
                        ,onInput Input
                        ,placeholder "github name"] []
viewButton model = button [disabled (String.length model.input < 1)] [text "Search"]

decodeUser : D.Decoder User
decodeUser = D.succeed User 
        |> P.required "login" D.string
        |> P.required "avatar_url" D.string
        |> P.required "html_url" D.string