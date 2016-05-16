module Questions exposing (..)

import List
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events as Events
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)

main : Program Never
main =
  Html.App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none }

--MODEL

type alias Question =
  { title : String
  , content : String }

type alias Model =
  { questions : List Question
  }

initialModel : Model
initialModel =
  { questions = []
  }

questionsDecoder : Json.Decoder (List Question)
questionsDecoder =
  Json.list questionDecoder

questionDecoder : Json.Decoder Question
questionDecoder =
  Json.object2
        Question
          ("title" := Json.string)
          ("content" := Json.string)

fetchData : Cmd Msg
fetchData =
  let
    url = "http://localhost:3000/api/questions"
  in
    Task.perform FetchFail FetchDone (Http.get questionsDecoder url)

--INIT

init : ( Model, Cmd Msg )
init =
  ( initialModel
  , fetchData )

--UPDATE

type Msg = NoOp
    | FetchData
    | FetchDone (List Question)
    | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoOp ->
      ( model, Cmd.none )
    FetchData ->
      ( model, fetchData)
    FetchDone results ->
      ( { model | questions = results }
      , Cmd.none )
    FetchFail error ->
      ( model, Cmd.none )

-- VIEW

questionView : Model -> Question -> Html Msg
questionView model question =
  div [ ]
    [ h3 [  ] [text question.title],
      h5 [  ] [text question.content]
    ]

questionsListView : Model -> Html Msg
questionsListView model =
  ul [ ]
    (model.questions |> List.map (questionView model))

view : Model -> Html Msg
view model =
  div [ ] [ questionsListView initialModel]

