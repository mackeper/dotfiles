#!/usr/bin/env bash

function echo_title() {
    echo -e "\n\033[37;44m $1\033[0m"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

commands=(
    'ln -s $SCRIPT_DIR/.tmux.conf ~/.tmux.conf'
    'ln -s $SCRIPT_DIR/.zshrc ~/.zshrc'
    'ln -s $SCRIPT_DIR/../../nvim ~/.config/nvim'
    'ln -s $SCRIPT_DIR/../../.gitconfig ~/.gitconfig'
)

echo_title "Copying configs"
for command in "${commands[@]}"; do
    echo "$command"
    eval $command
done
