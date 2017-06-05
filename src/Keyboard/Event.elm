module Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent, KeyCode, decodeKeyCode, decodeKey)

{-|
Most Elm keyboard-related packages (such as [elm-lang/keyboard][], and
others which build on it) are focused on installing a global handler for
keyboard events, to which one subscribes as needed.

[elm-lang/keyboard]: http://package.elm-lang.org/packages/elm-lang/keyboard/latest

An alternative approach would be to set up listeners for keyboard events in
your `view` method, as one would ordinarily listen for HTML events in Elm.  To
do that, you would need to decode the keyboard event which you will receive.
This package provides such decoders, so you can do something like this:

    div
        [ on "keydown" <|
            Json.Decode.map HandleKeyboardEvent decodeKeyboardEvent
        , tabindex 0
        , id "id-for-auto-focus"
        , style [ ( "outline", "none" ) ]
        ]
        [ ... ]

See the `examples` directory in the source code for complete examples.

Compared to using subscriptions, one advantage of this approach is that you get
more information from the keyboard event than the `KeyCode` which
[elm-lang/keyboard][] supplies:

  * the state of modifier keys (such as the shift key)

  * whether the event is a "repeated" keyboard event (due to a key being held
    down)

Note that an HTML element must be focused in order to receive keyboard events
(unlike in [elm-lang/keyboard][], since it attaches a listener to the
Javascript `window` object). This is either an advantage or a disadvantage,
depending on your circumstances. If you want to handle keyboard events
differently depending on what is focused, it is an advantage. Otherwise, you
can work around the need to focus, in this way:

  * provide the element with a `tabindex` attribute (as demonstrated above),
    so that it is focusable

  * possibly give it a style of `outline: none;` to avoid the default outline
    that would be drawn when the element is focused

  * possibly use [elm-lang/dom][] to automatically focus the element when
    you initialize the page

[elm-lang/dom]: http://package.elm-lang.org/packages/elm-lang/dom/latest

## KeyboardEvent

Decode a `KeyboardEvent` from an HTML [keyboard event][].

[keyboard event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent

@docs KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent

## Helpers

Some lower-level helpers that you might find useful.

@docs KeyCode, decodeKeyCode, decodeKey

-}

import Json.Decode exposing (Decoder, map, map7, int, field, oneOf, andThen, maybe, succeed, fail, bool, string)
import Keyboard.Key exposing (Key, fromCode)
import String


{-| A type alias for `Int`, as in [elm-lang/keyboard][].
-}
type alias KeyCode =
    Int


{-| Decodes `keyCode`, `which` or `charCode` from a [keyboard event][] to get a
numeric code for the key that was pressed.

[keyboard event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
-}
decodeKeyCode : Decoder KeyCode
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


{-| Decodes the `key` field from a [keyboard event][]. Results in
`Nothing` if the `key` field is not present, or blank.

[keyboard event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
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


{-| A representation of a [keyboard event][].

The `key` field may or may not be present, depending on the listener ("keydown"
vs. "keypress" vs. "keyup"), browser, and key pressed (character key vs.
special key). If not present, it will be `Nothing` here.

The `keyCode` is normalized by `decodeKeyboardEvent` to use whichever of
`which`, `keyCode` or `charCode` is provided, and made type-safe via
`Keyboard.Key` (see the excellent [SwiftsNamesake/proper-keyboard][] for
further manipulation of a `Key`).

[keyboard event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
[SwiftsNamesake/proper-keyboard]: http://package.elm-lang.org/packages/SwiftsNamesake/proper-keyboard/latest

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


{-| Decodes a `KeyboardEvent` from a [keyboard event][].

[keyboard event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
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


{-| You provide a function which, given a `KeyboardEvent`, turns it into a
message your `update` function can handle. You get back a `Decoder` for those
messages.

When your function returns `Nothing`, the decoder will fail. This means that
the event will simply be ignored -- that is, it will not reach your `update`
function at all.

Essentially, this allows you to filter keyboard events inside the decoder
itself, rather than in the `update` function. Whether this is a good idea or
not will depend on your scenario.
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
