module Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent)

{-| The existing Elm keyboard-related packages are focused on installing
a global handler for keyboard events, to which one subscribes as
needed.

An alternative approach would be to listen for events in your `view`
method, as one would ordinarily listen for HTML events in Elm.
To do that, you would need to decode the `KeyboardEvent` which you
will receive. This package provides such decoders.

Also mention `tabindex` and `focus` and `outline`.

@docs KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent

-}

import Json.Decode exposing (Decoder, map, map7, int, field, oneOf, andThen, maybe, succeed, fail, bool, string)
import Keyboard.Key exposing (Key, fromCode)
import String


{-| Decodes `keyCode` or `which` to get a numeric code for the key.
+Note that the numeric code does not change when the shift key is
+held down -- for that, you can decode the `.shfitKey`
-}
decodeKeyCode : Decoder Int
decodeKeyCode =
    oneOf
        [ field "keyCode" decodeNonZero
        , field "which" decodeNonZero
        , field "charCode" decodeNonZero

        -- In principle, we should always get some code, so instead
        -- of making this a Maybe, we succeed with 0.
        , succeed 0
        ]


{-| Decodes an Int, but only if it's not zero.
-}
decodeNonZero : Decoder Int
decodeNonZero =
    andThen
        (\code ->
            if code == 0 then
                fail "code was zero"
            else
                succeed code
        )
        int


{-| Decodes the key, but only if it's not blank.
-}
decodeKey : Decoder (Maybe String)
decodeKey =
    field "key" string
        |> andThen
            (\key ->
                if String.isEmpty key then
                    fail "empty key"
                else
                    succeed key
            )
        |> maybe


{-| A keyboard event.

The `key` field may or may not be present, depending on the listener ("keydown"
vs. "keypress" vs. "keyup"), browser, and key pressed (character key vs.
special key).

The `keyCode` is normalized by `decodeKeyboardEvent` to use whichever of
`which`, `keyCode` or `charCode` is provided, and made type-safe via
`Keyboard.Key` (see the excellent `SwiftsNamesake/proper-keyboard` for
further manipulation of a `Key`).

-}
type alias KeyboardEvent =
    { altKey : Bool
    , ctrlKey : Bool
    , key : Maybe String
    , keyCode : Key
    , metaKey : Bool
    , repeat : Bool
    , shiftKey : Bool
    }


{-| Decodes a keyboard event.
-}
decodeKeyboardEvent : Decoder KeyboardEvent
decodeKeyboardEvent =
    map7 KeyboardEvent
        (field "altKey" bool)
        (field "ctrlKey" bool)
        decodeKey
        (map fromCode decodeKeyCode)
        (field "metaKey" bool)
        (field "repeat" bool)
        (field "shiftKey" bool)


{-| You provide a function which, given a KeyboardEvent, turns it into a
msg you can handle. You get back a `Decoder`.

If your function returns `Nothing`, then the decoder will fail (which is
probably fine -- you're just ignoring that keyboard event).

-}
considerKeyboardEvent : (KeyboardEvent -> Maybe msg) -> Decoder msg
considerKeyboardEvent func =
    andThen
        (\event ->
            case func event of
                Just msg ->
                    succeed msg

                Nothing ->
                    fail "Ignoring keyboard event"
        )
        decodeKeyboardEvent
