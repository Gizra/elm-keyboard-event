#! /bin/sh

mkdir -p build/Keyboard
elm-make --yes src/Keyboard/Event.elm --output build/Keyboard/Event.js
cd examples
elm-make --yes OutermostDiv.elm --output ../build/OutermostDiv.html
elm-make --yes TwoDivs.elm --output ../build/TwoDivs.html
elm-make --yes Window.elm --output ../build/Window.html
