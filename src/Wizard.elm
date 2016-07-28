module Wizard exposing (Status(..), Model, Msg(..), init, update, view)


import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.App as App


main : Program Never
main =
  App.beginnerProgram
    { model = init 5
    , update = update
    , view = (view defaultGetIconLabel defaultGetContent)
    }


defaultGetIconLabel : Int -> (Html a, Html b)
defaultGetIconLabel id =
  (,) (text (toString id)) (text ("Step " ++ (toString id)))


defaultGetContent : Int -> Html msg
defaultGetContent id =
  div [] [ text ("Page content for step " ++ (toString id)) ]


-- MODEL


type Status
  = Current
  | Past
  | Future


type alias Step =
  { id : Int
  , status : Status
  }


type alias Model =
  { currentId : Int
  , steps : List Step
  }


init : Int -> Model
init numSteps =
  Model 0 (List.map initStep [ 0 .. numSteps-1 ])


initStep : Int -> Step
initStep id =
  Step id (if id == 0 then Current else Future)


-- UPDATE


type Msg
  = SetCurrent Int
  | Next
  | Prev


update : Msg -> Model -> Model
update msg model =
  case msg of
    SetCurrent id ->
      { model | currentId = id, steps = List.map (updateStep id) model.steps }

    Next ->
      if model.currentId == (List.length model.steps) - 1 then
        model
      else
        update (SetCurrent (model.currentId + 1)) model


    Prev ->
      if model.currentId == 0 then
        model
      else
        update (SetCurrent (model.currentId - 1)) model



updateStep : Int -> Step -> Step
updateStep currentId step =
  let
    status =
      if step.id < currentId then
        Past
      else if step.id == currentId then
        Current
      else
        Future
  in
    { step | status = status }


-- VIEW


view : (Int -> (Html Msg, Html Msg)) -> (Int -> Html Msg) -> Model -> Html Msg
view getIconLabel getContent model =
  div
    [ class "wizard" ]
    [ div
        [ class "wizardSteps" ]
        (List.map (viewStep getIconLabel) model.steps)
    , div
        [ class "wizardContent" ]
        [ getContent model.currentId ]
    ]


viewStep : (Int -> (Html Msg, Html Msg)) -> Step -> Html Msg
viewStep getIconLabel step =
  let
    (icon, label) = getIconLabel step.id
    className = statusClassName step.status
  in
    div
      [ class ("wizardStep " ++ className)
      , onClick (SetCurrent step.id)
      ]
      [ div
          [ class "wizardStepIconContainer" ]
          [ icon ]
      , div
          [ class "wizardStepLabelContainer" ]
          [ label ]
      ]


statusClassName : Status -> String
statusClassName status =
  case status of
    Current ->
      "current"

    Past ->
      "past"

    Future ->
      "future"
