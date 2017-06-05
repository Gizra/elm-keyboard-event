#! /bin/sh

elm-make --yes src/Keyboard/Event.elm
pushd examples
elm-make --yes BasicExample.elm --output BasicExample.html
popd
