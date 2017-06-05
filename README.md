[![Build Status](https://travis-ci.org/Gizra/elm-keyboard-event.svg?branch=master)](https://travis-ci.org/Gizra/elm-keyboard-event)

# elm-keyboard-event

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

You can then find the compiled examples in the `examples` folder.
