#!/usr/bin/env bash

sudo apt install neovim

# Needed by YouCompleteMe
sudo apt install build-essential cmake python3-dev

# NVim plugin manager
# https://github.com/junegunn/vim-plug
 curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/nvim
cp .config/nvim/init.vim ~/.config/nvim/init.vim
cp .config/nvim/global_extra_conf.py ~/.config/nvim/global_extra_conf.py
cp .config/nvim/readme.txt ~/.config/nvim/readme.txt

# Install powerline font
# https://github.com/powerline/fonts
# Window: Download as ZIP
# extract
# Dubble click the font (DejaVu Sans Mono for Powerline)
# OR
# Start powershell with admin
# run: Set-ExecutionPolicy Bypass
# Navigate to the folder
# run: .\install.ps1
# run: Set-ExecutionPolicy Default

# Or! In WSL right click top bar -> properties -> choose powerline font
# sudo apt install fonts-powerline

# Run :PlugInstall in nvim
vim +'PlugInstall --sync' +qa

# Install youcompleteme for clang
cd ~/.config/nvim/plugged/youcompleteme
python3 install.py --clang-completer

