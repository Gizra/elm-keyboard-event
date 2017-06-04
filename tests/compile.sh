#! /bin/sh

elm-make src/Keyboard/Event.elm
pushd examples
elm-make BasicExample.elm --output BasicExample.html
popd
