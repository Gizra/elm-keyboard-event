module Main exposing (Model, Msg(..), Target(..), init, leftSide, main, rightSide, source, subscriptions, update, view, viewEvent)

import Browser exposing (element)
import Html exposing (Attribute, Html, div, h1, h3, p, pre, text)
import Html.Attributes exposing (id, style, tabindex)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


main : Program Flags Model Msg
main =
    element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Target
    = Top
    | Bottom


type Msg
    = HandleKeyboardEvent Target KeyboardEvent
    | NoOp


type alias Model =
    { lastTopEvent : Maybe KeyboardEvent
    , lastBottomEvent : Maybe KeyboardEvent
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { lastTopEvent = Nothing
      , lastBottomEvent = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleKeyboardEvent target event ->
            case target of
                Top ->
                    ( { model | lastTopEvent = Just event }
                    , Cmd.none
                    )

                Bottom ->
                    ( { model | lastBottomEvent = Just event }
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
        [ style "position" "absolute"
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
        [ h1 [] [ text "Two Divs" ]
        , h3 [] [ text "An example of attaching a keydown listener to multiple divs." ]
        , p [] [ text "Click on an area below to focus it, and then press a key. I'll display the event." ]
        , viewEvent Top model.lastTopEvent
        , viewEvent Bottom model.lastBottomEvent
        ]


viewEvent : Target -> Maybe KeyboardEvent -> Html Msg
viewEvent target maybeEvent =
    let
        index =
            case target of
                Top ->
                    0

                Bottom ->
                    1

        viewMaybeEvent =
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
    in
    div
        [ style "height" "200px"
        , style "margin" "12px"
        , style "padding" "12px"
        , style "border" "1px dotted red"
        , tabindex index
        , on "keydown" (Json.map (HandleKeyboardEvent target) decodeKeyboardEvent)
        ]
        [ viewMaybeEvent ]


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
module Main exposing (Model, Msg(..), Target(..), init, leftSide, main, rightSide, source, subscriptions, update, view, viewEvent)

import Browser exposing (element)
import Html exposing (Attribute, Html, div, h1, h3, p, pre, text)
import Html.Attributes exposing (id, style, tabindex)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Task


main : Program Flags Model Msg
main =
    element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Target
    = Top
    | Bottom


type Msg
    = HandleKeyboardEvent Target KeyboardEvent
    | NoOp


type alias Model =
    { lastTopEvent : Maybe KeyboardEvent
    , lastBottomEvent : Maybe KeyboardEvent
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { lastTopEvent = Nothing
      , lastBottomEvent = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleKeyboardEvent target event ->
            case target of
                Top ->
                    ( { model | lastTopEvent = Just event }
                    , Cmd.none
                    )

                Bottom ->
                    ( { model | lastBottomEvent = Just event }
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
        [ style "position" "absolute"
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
        [ h1 [] [ text "Two Divs" ]
        , h3 [] [ text "An example of attaching a keydown listener to multiple divs." ]
        , p [] [ text "Click on an area below to focus it, and then press a key. I'll display the event." ]
        , viewEvent Top model.lastTopEvent
        , viewEvent Bottom model.lastBottomEvent
        ]


viewEvent : Target -> Maybe KeyboardEvent -> Html Msg
viewEvent target maybeEvent =
    let
        index =
            case target of
                Top ->
                    0

                Bottom ->
                    1

        viewMaybeEvent =
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
    in
    div
        [ style "height" "200px"
        , style "margin" "12px"
        , style "padding" "12px"
        , style "border" "1px dotted red"
        , tabindex index
        , on "keydown" (Json.map (HandleKeyboardEvent target) decodeKeyboardEvent)
        ]
        [ viewMaybeEvent ]


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
    "To avoid infinite recursion, I won't print the source here!"
"""
