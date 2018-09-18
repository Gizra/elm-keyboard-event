#! /bin/sh

mkdir -p build/Keyboard
elm make src/Keyboard/Event.elm --output build/Keyboard/Event.js
cd examples
elm make OutermostDiv.elm --output ../build/OutermostDiv.html
elm make TwoDivs.elm --output ../build/TwoDivs.html
elm make Document.elm --output ../build/Document.html
