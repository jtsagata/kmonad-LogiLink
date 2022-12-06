#!/bin/bash

set -o errexit
set -o pipefail

RESET='\e[0m'
RED='\e[31m'
GREEN='\e[32m'
OK="${GREEN}[OK]${RESET}"
ERROR="${RED}[ERROR]${RESET}"

declare -A HelpText

HelpText[services]="Complete system install"
function cmd_install() {
    cmd_system
    cmd_user
}


HelpText[system]="Install home directory staff"
function cmd_user() {
    echo "${GREEN}*** Installing user files${RESET}"
    echo "*** Install programm in ~/.local/bin"
    ln scripts/macro_keyboard ~/.local/bin/macro_keyboard

    echo "*** Install layout in ~/.config/macro_keyboard/layouts"
    mkdir -p ~/.config/macro_keyboard/layouts
    for file in layouts/*; do
        ln $file ~/.config/macro_keyboard/layouts/$file
    done

    echo "*** Install systemd template unit"
    mkdir -p ~/.config/systemd/user/
    ln tools/files/macro_keyboard@.service ~/.config/systemd/user/macro_keyboard@.service
    systemctl --user daemon-reload

    echo "*** Install compose files"
    ln XCompose ~/.XCompose
}


HelpText[system]="Install udev rules and add user to that groups"
function cmd_system() {
    echo "${GREEN}*** Installing system${RESET}"
    addgroup uinput
    usermod -a -G uinput "$(whoami)"
    usermod -a -G input "$(whoami)"
    cp files/keyboard_opts /etc/default/keyboard
    cp files/10-uinput.rules /etc/udev/rules.d/

}

HelpText[build]="Install Haskell and compile kmonad"
function cmd_build() {
    echo "${GREEN}*** Building kmonad from scratch${RESET}"
    echo "${RED}*** This will take some time{RESET}"
    mkdir -p ~/Builds
    mkdir -p ~/.local/bin

    cd ~/Builds
    git clone https://github.com/kmonad/kmonad

    cd kmonad
    sudo apt install haskell-stack
    stack build
    stack install
    echo "${GREEN}*** Done${RESET}"
}


function cmd_help() {
    echo "Subcommands"
    for i in "${!HelpText[@]}"
    do
        printf "%10s: %s\n" "$i" "${HelpText[$i]}"
    done
}

### Run the command
command=${1-help}
shift || true
func=cmd_"${command}"
if [ "$(type -t "$func")" == "function" ]; then
    $func "$@"
else
    printf "Unknown command %s\n" "$command"
    cmd_help
fi

