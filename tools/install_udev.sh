#!/bin/bash

addgroup uinput
usermod -a -G uinput $(whoami)
cp files/keyboard_opts /etc/default/keyboard
cp files/10-uinput.rules /etc/udev/rules.d/