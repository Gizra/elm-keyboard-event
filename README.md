[![Build Status](https://travis-ci.org/Gizra/elm-keyboard-event.svg?branch=master)](https://travis-ci.org/Gizra/elm-keyboard-event)

# elm-keyboard-event

Most Elm keyboard-related packages (such as [elm-lang/keyboard][keyboard-pkg], and
others which build on it) only decode the `KeyCode` from Javascript's
[keyboard event][keyboard-event] (possiby building up some additional state from the
sequence of keycodes).

[keyboard-pkg]: http://package.elm-lang.org/packages/elm-lang/keyboard/latest
[keyboard-event]: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent

This ignores some potentially useful information reported in Javascript's
[keyboard event][keyboard-event]:

  * the state of modifier keys (such as the shift key)

  * whether the event is a "repeated" keyboard event (due to a key being held
    down)

This package provides decoders for that additional information, and examples
of using those decoders when listening for keyboard events on HTML elements,
or the `window` object itself (as [elm-lang/keyboard][keyboard-pkg] does).

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
See the `examples` directory in the source code for complete examples.

  * [Listen for events on an outermost div](https://gizra.github.io/elm-keyboard-event/OutermostDiv.html)
  * [Listen for events on multiple divs](https://gizra.github.io/elm-keyboard-event/TwoDivs.html)
  * [Listen for events on the `window` object](https://gizra.github.io/elm-keyboard-event/Window.html)

Note that an HTML element must be focused in order to receive keyboard events
(unlike in [elm-lang/keyboard][keyboard-pkg], since it attaches a listener to the
Javascript `window` object). This is either an advantage or a disadvantage,
depending on your circumstances. If you want to handle keyboard events
differently depending on what is focused, it is an advantage. Otherwise, you
can work around the need to focus, in this way:

  * provide the element with a `tabindex` attribute (as demonstrated above),
    so that it is focusable

  * possibly give it a style of `outline: none;` to avoid the default outline
    that would be drawn when the element is focused

  * possibly use [elm-lang/dom][dom-package] to automatically focus the element when
    you initialize the page

[dom-package]: http://package.elm-lang.org/packages/elm-lang/dom/latest

Alternatively, the `examples` directory also
[contains an example](https://gizra.github.io/elm-keyboard-event/Window.html)
of subscribing to keyboard events on the `window` object, as
[elm-lang/keyboard][keyboard-pkg] does, but supplying your own decoder instead
of just getting the `KeyCode`. In that case, you can avoid the need to focus on
any particular HTML element.

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
