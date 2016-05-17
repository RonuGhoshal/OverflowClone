module Questions exposing (..)

import List
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events as Events
import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Debug

main : Program Never
main =
  Html.App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none }

--MODEL

type alias Vote =
  { id : Int
  }

type alias Answer =
  { id : Int
  , content : String
  }

type alias Question =
  { id : Int
  , title : String
  , content : String
  , votes : List Vote
  , answers : List Answer
  }

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
  Json.object5
        Question
          ("id" := Json.int)
          ("title" := Json.string)
          ("content" := Json.string)
          ("votes" := Json.list voteDecoder)
          ("answers" := Json.list answerDecoder)

voteDecoder : Json.Decoder Vote
voteDecoder =
  Json.object1
    Vote
    ("id" := Json.int)

answerDecoder : Json.Decoder Answer
answerDecoder =
  Json.object2
    Answer
    ("id" := Json.int)
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
update msg model =
  case msg of
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
  div [ id ("question" ++ (toString question.id)) ]
    [ h3 [  ] [text question.title]
    , h5 [  ] [text question.content]
    , div [  ][span [ ] [text ((toString (List.length question.votes)) ++ " votes ")],
                 a [ href ("http://localhost:3000/api/questions/" ++ toString (question.id) ++ "/votes")] [text "(Upvote)" ]
                ]
    , div [ ][ span [ ][text ((toString (List.length question.answers)) ++ " answers ")]
    ]
    , answerListView question
    ]



questionsListView : Model -> Html Msg
questionsListView model =
  ul [ ]
    (model.questions |> List.map (questionView model))

answerView : Question -> Answer -> Html Msg
answerView question answer =
  div [ ]
    [ h5 [  ] [text answer.content]
    ]

answerListView : Question -> Html Msg
answerListView question =
  ul [ id ("answers" ++ (toString question.id)), style [("display", "none")] ]
    (question.answers |> List.map (answerView question))

view : Model -> Html Msg
view model =
    div [ ]
    [ h1 [  ] [text "SLACK OVERFLOW"]
    , questionsListView model
    ]

