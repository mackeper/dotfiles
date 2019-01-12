#!/usr/bin/env bash

# NVim plugin manager
# https://github.com/junegunn/vim-plug
 curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/nvim
cp .config/nvim/init.vim 

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
