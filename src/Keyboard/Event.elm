module Keyboard.Event exposing
    ( KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent
    , KeyCode, decodeKeyCode, decodeKey
    )

{-| There are various ways to listen to
[keyboard events](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent)
in Elm. If you want to get all keyboard events, you can subscribe using functions from
[Browser.Events](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events).
And, if you want to get keyboard events for specific HTML elements, you can use
[Html.Events.on](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#on).

Each of those functions asks you to provide a `Decoder msg` to convert the
keyboard event into a message your application can handle. To help you along
the way, `Html.Events` has a handy
[keyCode](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#keyCode)
decoder. You can use it to turn the keyboard event into a keycode -- which you
can then map into a message your app understands.

However, there is more information available in a keyboard event than just the
keycode. So, we provide a decoder which gives you all the available
information:

    type alias KeyboardEvent =
        { altKey : Bool
        , ctrlKey : Bool
        , key : Maybe String
        , keyCode : Key
        , metaKey : Bool
        , repeat : Bool
        , shiftKey : Bool
        }

Even better, we:

  - normalize some browser-specific quirks, such as where to look for the keyCode
    (under "keyCode", "which" or "charCode")

  - turn the keyCode into a type-safe `Key` value.

But wait, there's more! We also have a version of the keyboard event decoder
which allows you to filter events right in the decoder. That way, you can
prevent some events from reaching your update function at all, which can be
useful in some scenarios.


## Examples

To listen for keyboard events on HTML elements, you can do something like this:

    div
        [ on "keydown" <|
            Json.Decode.map HandleKeyboardEvent decodeKeyboardEvent
        , tabindex 0
        , id "id-for-auto-focus"
        , style [ ( "outline", "none" ) ]
        ]
        []

We use the`tabIndex` attribute to make the element focusable, since an HTML
element must be focusable in order to receive keyboard events. And, we provide
an `id` in case we want to programmatically focus on the element, via
[Browser.Dom.focus](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#focus).

For complete examples, see:

  - [Listen for events on an outermost div](https://gizra.github.io/elm-keyboard-event/OutermostDiv.html)
  - [Listen for events on multiple divs](https://gizra.github.io/elm-keyboard-event/TwoDivs.html)

To listen for keyboard events globally, you can use functions from
[Browser.Events](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events)
to subscribe to all keyboard events. For an example, see

  - [Listen for events on the `document` object](https://gizra.github.io/elm-keyboard-event/Document.html)


## KeyboardEvent

@docs KeyboardEvent, decodeKeyboardEvent, considerKeyboardEvent


## Helpers

Some lower-level helpers that you might find useful.

@docs KeyCode, decodeKeyCode, decodeKey

-}

import Json.Decode exposing (Decoder, andThen, bool, fail, field, int, map, map7, maybe, oneOf, string, succeed)
import Keyboard.Key exposing (Key, fromCode)
import String


{-| A type alias for `Int`.
-}
type alias KeyCode =
    Int


{-| Decodes `keyCode`, `which` or `charCode` from a [keyboard event][keyboard-event]
to get a numeric code for the key that was pressed.

[keyboard-event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent

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


{-| Decodes the `key` field from a [keyboard event][keyboard-event].
Results in `Nothing` if the `key` field is not present, or blank.

[keyboard-event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent

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


{-| A representation of a [keyboard event][keyboard-event].

The `key` field may or may not be present, depending on the listener ("keydown"
vs. "keypress" vs. "keyup"), browser, and key pressed (character key vs.
special key). If not present, it will be `Nothing` here.

The `keyCode` is normalized by `decodeKeyboardEvent` to use whichever of
`which`, `keyCode` or `charCode` is provided, and made type-safe via
`Keyboard.Key`
(see the excellent [SwiftsNamesake/proper-keyboard][proper-keyboard-pkg] for
further manipulation of a `Key`).

[keyboard-event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent
[proper-keyboard-pkg]: http://package.elm-lang.org/packages/SwiftsNamesake/proper-keyboard/latest

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


{-| Decodes a `KeyboardEvent` from a [keyboard event][keyboard-event].

[keyboard-event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent

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
