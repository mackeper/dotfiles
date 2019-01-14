#!/usr/bin/env bash

sudo apt install git
sudo apt install curl
sudo apt install zsh

#OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# base16 colors
# https://github.com/chriskempson/base16-shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

cp .bashrc_WSL ~/.bashrc
cp .zshrc ~/.zshrc
