module Main exposing (Model, Msg(..), init, leftSide, main, rightSide, source, subscriptions, update, view, viewEvent)

import Browser exposing (element)
import Browser.Dom as Dom
import Html exposing (Attribute, Html, div, h1, h3, p, pre, text)
import Html.Attributes exposing (id, style, tabindex)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


type alias Flags =
    {}


main : Program Flags Model Msg
main =
    element
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


{-| Note that we automatically focus on the outermost div, since
the browser will only send keyboard events to a focused element.
-}
init : Flags -> ( Model, Cmd Msg )
init _ =
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


{-| Note that we use a `tabindex` to make the div focusable.
-}
view : Model -> Html Msg
view model =
    div
        [ on "keydown" <|
            Json.map HandleKeyboardEvent decodeKeyboardEvent
        , tabindex 0
        , id "outermost"
        , style "position" "absolute"
        , style "height" "100%"
        , style "width" "100%"
        , style "overflow" "hidden"
        , style "outline" "none"
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
        [ h1 [] [ text "Outermost Div" ]
        , h3 [] [ text "An example of attaching a keydown listener to the outermost div you create." ]
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
module Main exposing (Model, Msg(..), init, leftSide, main, rightSide, source, subscriptions, update, view, viewEvent)

import Browser exposing (element)
import Browser.Dom as Dom
import Html exposing (Attribute, Html, div, h1, h3, p, pre, text)
import Html.Attributes exposing (id, style, tabindex)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


type alias Flags =
    {}


main : Program Flags Model Msg
main =
    element
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


{-| Note that we automatically focus on the outermost div, since
the browser will only send keyboard events to a focused element.
-}
init : Flags -> ( Model, Cmd Msg )
init _ =
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


{-| Note that we use a `tabindex` to make the div focusable.
-}
view : Model -> Html Msg
view model =
    div
        [ on "keydown" <|
            Json.map HandleKeyboardEvent decodeKeyboardEvent
        , tabindex 0
        , id "outermost"
        , style "position" "absolute"
        , style "height" "100%"
        , style "width" "100%"
        , style "overflow" "hidden"
        , style "outline" "none"
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
        [ h1 [] [ text "Outermost Div" ]
        , h3 [] [ text "An example of attaching a keydown listener to the outermost div you create." ]
        , p [] [ text "Press a key, and I'll display the event below." ]
        , viewEvent model.lastEvent
        ]


viewEvent : Maybe KeyboardEvent -> Html Msg
viewEvent maybeEvent =
    case maybeEvent of
        Just event ->
            pre []
                [ text <|
                    String.join "
"
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
    "To avoid inifinite recursion, we won't print the source here!"
"""
