#! /bin/sh

elm-make --yes src/Keyboard/Event.elm
cd examples
elm-make --yes BasicExample.elm --output BasicExample.html
