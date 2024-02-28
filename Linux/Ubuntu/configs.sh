#!/usr/bin/env bash

function echo_title() {
    echo -e "\n\033[37;44m $1\033[0m"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo_title "Copying config files"
echo "cp $SCRIPT_DIR/.tmux.conf ~/.tmux.conf"
echo "cp $SCRIPT_DIR/.zshrc ~/.zshrc"
echo "cp -r $SCRIPT_DIR/../../nvim ~/.config"
