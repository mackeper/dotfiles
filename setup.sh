#!/usr/bin/env bash
packages=()
yaourt_packages=()

# Shell/terminal
packages+=(zsh)
packages+=(urxvt)

# Video
packages+=(xrandr)  # video output setting
packages+=(mpv)     # video viewer

# audio
packages+=(pavucontrol) # Audio settings

# Download
packages+=(peerflix)        # Stream torrent
packages+=(transmission)
packages+=(wget)
packages+=(curl)

# Network
packages+=(openvpn)
packages+=(openssh)

packages+=(networkmanager)
packages+=(network-manager-applet)
packages+=(networkmanager-openvpn)

# Process management
packages+=(htop)
packages+=(gotop)

# Development
packages+=(neovim)
packages+=(nano)

packages+=(git)

packages+=(make)
packages+=(man-db)
packages+=(man-pages)

packages+=(python3)
packages+=(ghc)
packages+=(nodejs)
packages+=(npm)
packages+=(rust)

packages+=(binutils) # gcc -pg -> ./a.out -> gprof ./a.out gmon.out

# Compression/Encryption
packages+=(tar)
packages+=(zip)
packages+=(unzip)
packages+=(openssl)

# unixporn good looking
yaourt_packages+=(tty-clock)    # Clock in terminal
yaourt_packages+=(cava)         # Audio visualizer
packages+=(lolcat)              # rainbow colors
packages+=(neofetch)            # images of distro and specs
packages+=(feh)                 # set wallpaper
packages+=(powerline)           # cool font

# Tools
packages+=(tldr)        # shorter man
packages+=(scrot)       #screenshots
packages+=(grep)
packages+=(blueman)     # bluetooth
packages+=(aspell)

# Window manager
packages+=(i3-gaps)
packages+=(i3-status)
packages+=(i3lock)       # lock screen

# Browser
packages+=(google-chrome)

# PDF
packages+=(zathura)

# Virtualbox probably best manually because its kernel depended.
# sudo pacman -S virtualbox-guest-utils (in guest)
# xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
# xrandr --addmode Virtual1 1920x1080
# xrandr --output Virtual1 --mode 1920x1080


for i in "${packages[@]}"; do
    echo "$i"
done

# Other stuff
# Yaourt
# git clone https://aur.archlinux.org/yaourt.git
# cd yaourt/
# makepkg -si

#OhMyZsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# base16 colors
# https://github.com/chriskempson/base16-shell
#git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

#cp .bashrc_WSL ~/.bashrc
#cp .zshrc ~/.zshrc

# Setup nvim
## NVim plugin manager
## https://github.com/junegunn/vim-plug
 curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/nvim
cp .config/nvim/init.vim ~/.config/nvim/init.vim
cp .config/nvim/global_extra_conf.py ~/.config/nvim/global_extra_conf.py
cp .config/nvim/readme.txt ~/.config/nvim/readme.txt

## Run :PlugInstall in nvim
nvim +'PlugInstall --sync' +qa

# Install youcompleteme
cd ~/.config/nvim/plugged/youcompleteme
python3 install.py --clang-completer
python3 install.py --rust-completer
python3 install.py --ts-completer
