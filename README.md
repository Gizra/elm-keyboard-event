[![Build Status](https://travis-ci.org/Gizra/elm-keyboard-event.svg?branch=master)](https://travis-ci.org/Gizra/elm-keyboard-event)

# elm-keyboard-event

The existing Elm keyboard-related packages are focused on installing
a global handler for keyboard events, to which one subscribes as
needed.

An alternative approach would be to listen for events in your `view`
method, as one would ordinarily listen for HTML events in Elm.
To do that, you would need to decode the `KeyboardEvent` which you
will receive. This package provides such decoders.

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
