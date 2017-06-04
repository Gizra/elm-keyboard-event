module Main exposing (..)

import Dom
import Html exposing (Html, p, div, h1, text, program, pre)
import Html.Attributes exposing (tabindex, id, style)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Msg
    = HandleKeyboardEvent KeyboardEvent
    | NoOp


type alias Model =
    { lastEvent : Maybe KeyboardEvent
    }


init : ( Model, Cmd Msg )
init =
    ( { lastEvent = Nothing }
    , Dom.focus "outermost"
        |> Task.attempt (always NoOp)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleKeyboardEvent event ->
            ( { model | lastEvent = Just event }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div
        [ on "keydown" <|
            Json.map HandleKeyboardEvent decodeKeyboardEvent
        , tabindex 0
        , id "outermost"
        , style
            [ ( "margin-left", "6px" )
            , ( "outline", "none" )
            ]
        ]
        [ h1 [] [ text "Basic Example" ]
        , p [] [ text "Press a key, and I'll display the event below." ]
        , viewEvent model.lastEvent
        ]


viewEvent : Maybe KeyboardEvent -> Html Msg
viewEvent maybeEvent =
    case maybeEvent of
        Just event ->
            pre []
                [ text <|
                    String.join "\n"
                        [ "altKey: " ++ toString event.altKey
                        , "ctrlKey: " ++ toString event.ctrlKey
                        , "key: " ++ toString event.key
                        , "keyCode: " ++ toString event.keyCode
                        , "metaKey: " ++ toString event.metaKey
                        , "repeat: " ++ toString event.repeat
                        , "shiftKey: " ++ toString event.shiftKey
                        ]
                ]

        Nothing ->
            p [] [ text "No event yet" ]
