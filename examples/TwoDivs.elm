module Main exposing (..)

import Dom
import Html exposing (Html, Attribute, p, div, h1, h3, text, program, pre)
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


init : ( Model, Cmd Msg )
init =
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
        [ style
            [ ( "position", "absolute" )
            , ( "height", "100%" )
            , ( "width", "100%" )
            , ( "overflow", "hidden" )
            , ( "outline", "none" )
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

        viewEvent =
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
    in
        div
            [ style
                [ ( "height", "200px" )
                , ( "margin", "12px" )
                , ( "padding", "12px" )
                , ( "border", "1px dotted red" )
                ]
            , tabindex index
            , on "keydown" (Json.map (HandleKeyboardEvent target) decodeKeyboardEvent)
            ]
            [ viewEvent ]


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
    """
module Main exposing (..)

import Dom
import Html exposing (Html, Attribute, p, div, h1, h3, text, program, pre)
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


init : ( Model, Cmd Msg )
init =
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
        [ style
            [ ( "position", "absolute" )
            , ( "height", "100%" )
            , ( "width", "100%" )
            , ( "overflow", "hidden" )
            , ( "outline", "none" )
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

        viewEvent =
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
    in
        div
            [ style
                [ ( "height", "200px" )
                , ( "margin", "12px" )
                , ( "padding", "12px" )
                , ( "border", "1px dotted red" )
                ]
            , tabindex index
            , on "keydown" (Json.map (HandleKeyboardEvent target) decodeKeyboardEvent)
            ]
            [ viewEvent ]


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
