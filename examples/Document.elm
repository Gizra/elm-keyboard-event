module Main exposing (Model, Msg(..), init, leftSide, main, rightSide, source, subscriptions, update, view, viewEvent)

import Browser exposing (element)
import Browser.Events exposing (onKeyDown)
import Html exposing (Attribute, Html, div, h1, h3, p, pre, text)
import Html.Attributes exposing (id, style, tabindex)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


main : Program () Model Msg
main =
    element
        { init = always init
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
    , Cmd.none
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
    onKeyDown (Json.map HandleKeyboardEvent decodeKeyboardEvent)


{-| Note that we use a `tabindex` to make the div focusable.
-}
view : Model -> Html Msg
view model =
    div
        [ style "position" "absolute"
        , style "height" "100%"
        , style "width" "100%"
        , style "overflow" "hidden"
        ]
        [ div []
            [ leftSide model
            , rightSide
            ]
        ]


leftSide : Model -> Html Msg
leftSide model =
    div
        [ style "position" "absolute"
        , style "left" "0px"
        , style "right" "65%"
        , style "height" "100%"
        , style "margin" "18px"
        , style "overflow" "hidden"
        ]
        [ h1 [] [ text "Handler on Document" ]
        , h3 [] [ text "An example of attaching a keydown listener to the `document` object." ]
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
                        [ "altKey: " ++ Debug.toString event.altKey
                        , "ctrlKey: " ++ Debug.toString event.ctrlKey
                        , "key: " ++ Debug.toString event.key
                        , "keyCode: " ++ Debug.toString event.keyCode
                        , "metaKey: " ++ Debug.toString event.metaKey
                        , "repeat: " ++ Debug.toString event.repeat
                        , "shiftKey: " ++ Debug.toString event.shiftKey
                        ]
                ]

        Nothing ->
            p [] [ text "No event yet" ]


rightSide : Html Msg
rightSide =
    pre
        [ style "position" "absolute"
        , style "left" "35%"
        , style "right" "0px"
        , style "height" "100%"
        , style "margin" "18px"
        , style "overflow" "auto"
        ]
        [ text source ]


source : String
source =
    """
module Main exposing (..)

import Html exposing (Html, Attribute, p, div, h1, h3, text, program, pre)
import Html.Attributes exposing (tabindex, id, style)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task
import Window.Events exposing (onWindow)


main : Program Never Model Msg
main =
    program
        { init = always init
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
    , Cmd.none
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
    onWindow "keydown" (Json.map HandleKeyboardEvent decodeKeyboardEvent)


{-| Note that we use a `tabindex` to make the div focusable.
-}
view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "height", "100%" )
            , ( "width", "100%" )
            , ( "overflow", "hidden" )
            ]
        ]
        [ div []
            [ leftSide model
            , rightSide
            ]
        ]


leftSide : Model -> Html Msg
leftSide model =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "left", "0px" )
            , ( "right", "65%" )
            , ( "height", "100%" )
            , ( "margin", "18px" )
            , ( "overflow", "hidden" )
            ]
        ]
        [ h1 [] [ text "Handler on Window" ]
        , h3 [] [ text "An example of attaching a keydown listener to the `window` object." ]
        , p [] [ text "Press a key, and I'll display the event below." ]
        , viewEvent model.lastEvent
        ]


viewEvent : Maybe KeyboardEvent -> Html Msg
viewEvent maybeEvent =
    case maybeEvent of
        Just event ->
            pre []
                [ text <|
                    String.join "\\n"
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


rightSide : Html Msg
rightSide =
    pre
        [ style
            [ ( "position", "absolute" )
            , ( "left", "35%" )
            , ( "right", "0px" )
            , ( "height", "100%" )
            , ( "margin", "18px" )
            , ( "overflow", "auto" )
            ]
        ]
        [ text source ]


source : String
source =
    "To avoid infinite recursion, I shall not repeat the source here."
"""
