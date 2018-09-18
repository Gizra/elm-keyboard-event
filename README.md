[![Build Status](https://travis-ci.org/Gizra/elm-keyboard-event.svg?branch=master)](https://travis-ci.org/Gizra/elm-keyboard-event)

# elm-keyboard-event

This module provides decoders for
[keyboard events](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent)
with several useful features:

- They preserve more information than just the
  [keyCode](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#keyCode).

- They normalize some browser-specific quirks.

- You can filter keyboard events right in the decoder (rather than sending
  all events to your update function).

## Background

There are various ways to listen to
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

```elm
type alias KeyboardEvent =
    { altKey : Bool
    , ctrlKey : Bool
    , key : Maybe String
    , keyCode : Key
    , metaKey : Bool
    , repeat : Bool
    , shiftKey : Bool
    }
```

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

```elm
div
    [ on "keydown" <|
        Json.Decode.map HandleKeyboardEvent decodeKeyboardEvent
    , tabindex 0
    , id "id-for-auto-focus"
    , style [ ( "outline", "none" ) ]
    ]
    []
```

We use the`tabIndex` attribute to make the element focusable, since an HTML
element must be focusable in order to receive keyboard events. And, we provide
an `id` in case we want to programmatically focus on the element, via
[Browser.Dom.focus](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#focus).

For complete examples, see:

  * [Listen for events on an outermost div](https://gizra.github.io/elm-keyboard-event/OutermostDiv.html)
  * [Listen for events on multiple divs](https://gizra.github.io/elm-keyboard-event/TwoDivs.html)

To listen for keyboard events globally, you can use functions from
[Browser.Events](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events) 
to subscribe to all keyboard events. For an example, see

  * [Listen for events on the `document` object](https://gizra.github.io/elm-keyboard-event/Document.html)

## API

For the detailed API, see the
[Elm package site](http://package.elm-lang.org/packages/Gizra/elm-keyboard-event/latest),
or the links to the right, if you're already there.

## Installation

Try `elm-package install Gizra/elm-keyboard-event`

## Development

Try something like:

    git clone https://github.com/Gizra/elm-keyboard-event
    cd elm-keyboard-event
    npm install
    npm test

You can then find the compiled examples in the `build` folder.
