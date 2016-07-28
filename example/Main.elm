import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Wizard exposing (..)

main : Program Never
main =
  App.beginnerProgram
    { model = Wizard.init (List.length steps)
    , update = update
    , view = view
    }


-- STEPS


steps =
  [ { label = "Step 1"
    , content = "Some content for step 1"
    }
  , { label = "Step 2"
    , content = "Some content for step 2"
    }
  , { label = "Step 3"
    , content = "Some content for step 3"
    }
  ]


getLabel : Int -> String
getLabel index =
  getStepField .label index steps


getContent : Int -> String
getContent index =
  getStepField .content index steps


getStepField getMember index steps =
  case steps of
    head :: rest ->
      if index == 0 then
        getMember head
      else
        getStepField getMember (index - 1) rest

    [] ->
      ""


-- UPDATE


type Msg
  = Child Wizard.Msg
  | Next
  | Prev


update : Msg -> Wizard.Model -> Wizard.Model
update msg model =
  case msg of
    Child msg ->
      Wizard.update msg model

    Next ->
      Wizard.update Wizard.Next model

    Prev ->
      Wizard.update Wizard.Prev model


-- VIEW


view : Wizard.Model -> Html Msg
view model =
  div
    [ class "container" ]
    [ h1
        []
        [ text "Elm Wizard Example" ]
    , div
        [ class "wizardContainer" ]
        [ App.map Child (Wizard.view getIconLabel getStepContent model) ]
    , div
        [ class "buttons" ]
        [ button [ onClick Prev ] [ text "Prev" ]
        , button [ onClick Next ] [ text "Next" ]
        ]
    ]


getIconLabel : Int -> (Html a, Html b)
getIconLabel index =
  (,) (text (toString (index + 1))) (text (getLabel index))


getStepContent : Int -> (Html msg)
getStepContent index =
  (text (getContent index))
