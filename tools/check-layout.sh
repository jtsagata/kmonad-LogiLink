#!/bin/bash 
SCRIPT=${1:-default.kbd}

if ~/.local/bin/kmonad $SCRIPT -d ; then
    python3 ./tools/kmonad_dump.py $SCRIPT | sed 's/none//g' | xclip -selection c
    echo "*** Copy to clipbard"
    echo "Paste to: http://www.keyboard-layout-editor.com/#/"
else
    echo "ERROR in keyboard configuration"
fi