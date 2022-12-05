#!/bin/bash

SCRIPT=${1:-default.kbd}

process_id=$(pgrep --euid "$EUID" kmonad )
if [[ "$process_id" != "" ]]; then
    kill "$process_id"
fi

if ~/.local/bin/kmonad $SCRIPT -d ; then
    ~/.local/bin/kmonad $SCRIPT
    echo "*** Terminated"
else
    echo "ERROR in keyboard configuration"
fi