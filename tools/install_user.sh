#!/bin/bash

ln scripts/macro_keyboard ~/.local/bin/macro_keyboard

mkdir -p ~/.config/macro_keyboard/layouts
for file in layouts/*; do
    ln $file ~/.config/macro_keyboard/layouts/$file
done

mkdir -p ~/.config/systemd/user/
ln tools/files/macro_keyboard@.service ~/.config/systemd/user/macro_keyboard@.service
systemctl --user daemon-reload
