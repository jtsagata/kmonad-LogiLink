#!/bin/bash

mkdir -p ~/Builds
mkdir -p ~/.local/bin

cd ~/Builds
git clone https://github.com/kmonad/kmonad

cd kmonad
sudo apt install haskell-stack
stack build
stack install