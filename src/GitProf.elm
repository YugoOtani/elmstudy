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
type alias Model = {input : String, result : String}
type Msg = Search | GotRepo (Result Http.Error String) | Input String
type alias User = 
    { login : String
    ,avator : String
    ,prof : String
    }   

init : () -> (Model, Cmd Msg)
init _ = ({input = "", result = ""}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        Search -> (model, Http.get{
            url = "http://api.github.com/users/" ++ model.input
            , expect = Http.expectString GotRepo --use expectJson
            })
        Input s -> ({model | input = s},Cmd.none)
        GotRepo (Ok repo) -> ({model | result = repo}, Cmd.none)
        GotRepo (Err err) -> ({model | result = ""}, Cmd.none)

view : Model -> Html Msg
view model = div [] 
    [Html.form [onSubmit Search] [viewInput model, viewButton model]
    ,p [] (viewResult model) 
    ]
viewInput model = input [value model.input
                        ,onInput Input
                        ,placeholder "github name"] []
viewButton model = button [disabled (String.length model.input < 1)] [text "Search"]
viewResult model = case model.result of
                    "" -> [text "no such user"]
                    s  -> case D.decodeString decodeUser s of
                            Ok(usr) -> [text (Debug.toString usr)]
                            Err(er) -> [text (Debug.toString er)]
decodeUser : D.Decoder User
decodeUser = D.succeed User 
        |> P.required "login" D.string
        |> P.required "avatar_url" D.string
        |> P.required "html_url" D.string