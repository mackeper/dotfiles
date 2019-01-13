#!/usr/bin/env bash

sudo apt install zsh

# base16 colors
# https://github.com/chriskempson/base16-shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

cp .bashrc_WSL ~/.bashrc
cp .zshrc ~/.zshrc

# Install powerline font
# https://github.com/powerline/fonts
# Window: Download as ZIP
# extract
# Start powershell with admin
# run: Set-ExecutionPolicy Bypass
# Navigate to the folder
# run: .\install.ps1
# run: Set-ExecutionPolicy Default

# Run :PlugInstall in nvim
