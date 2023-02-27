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
type alias Model = {input : String, usr : User, state : State}
type Msg = Search | GotRepo (Result Http.Error User) | Input String
type alias User = 
    { name : String
    ,avator : String
    ,prof : String
    }  
type State = NotFound | Loading | ShowUser | NoInput | SomeInput
emptyUser = { name = ""
            ,avator = ""
            ,prof   = ""
            }
init : () -> (Model, Cmd Msg)
init _ = ({input = "", usr = emptyUser, state = NoInput}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        Search -> ({model | state = Loading}, Http.get{
            url = "http://api.github.com/users/" ++ model.input
            , expect = Http.expectJson GotRepo decodeUser
            })
        Input s -> ({model | input = s, state = if s=="" then NoInput else SomeInput},Cmd.none)
        GotRepo (Ok repo) -> ({model | usr = repo, state = ShowUser}, Cmd.none)
        GotRepo (Err err) -> ({model | usr = emptyUser, state = NotFound}, Cmd.none)

view : Model -> Html Msg
view model = div [] 
    [Html.form [onSubmit Search] [viewInput model, viewButton model]
    ,viewUser model.usr model.state
    ]
viewInput model = input [value model.input
                        ,onInput Input
                        ,placeholder "github name"] []
viewButton model = button [disabled (String.length model.input < 1)] [text "Search"]

viewUser usr state = case state of
            NotFound -> text "no such user"
            Loading  -> text "loading ... "
            NoInput  -> text "usage : input github username in textbox and press search"
            SomeInput -> text "press search to show user"
            ShowUser -> div [] [
                            p [] [img [src usr.avator, width 200] []]
                            ,a [href usr.prof] [text usr.name]
                        ]

decodeUser : D.Decoder User
decodeUser = D.succeed User 
        |> P.required "login" D.string
        |> P.required "avatar_url" D.string
        |> P.required "html_url" D.string