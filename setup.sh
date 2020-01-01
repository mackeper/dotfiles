#!/usr/bin/env bash
# Assumes you have the git repo dotfiles in ~

# Move to ~/tmp
cd ~
mkdir tmp
cd tmp

# ============== List all packages ===================
packages=()
yaourt_packages=()
pip_packages=()

## Shell/terminal
packages+=(zsh)
packages+=(rxvt-unicode)
yaourt_packages+=(urxvt-resize-font-git)

packages+=(fzf)         # Fuzzy finder (terminal navigation)

## Video
packages+=(libxrandr)   # video output setting
packages+=(mpv)         # video viewer

## audio
packages+=(pavucontrol)             # Audio settings
packages+=(pulseaudio-bluetooth)    # bluetooth
packages+=(bluez)                   # bluetooth
packages+=(bluez-utils)             # bluetooth

# I/O packages

packages+=(xinput)

## Download
yaourt_packages+=(peerflix)        # Stream torrent
packages+=(transmission-cli)
packages+=(wget)
packages+=(curl)

## Network
packages+=(openvpn)
packages+=(openssh)

packages+=(networkmanager)
packages+=(network-manager-applet)
packages+=(networkmanager-openvpn)

## Process management
packages+=(htop)

## Development
packages+=(base-devel)

packages+=(neovim)
packages+=(nano)

packages+=(git)

packages+=(make)
packages+=(cmake)
packages+=(man-db)
packages+=(man-pages)
packages+=(valgrind)
packages+=(gdb)

packages+=(python3)
packages+=(python-pip)
packages+=(ghc)
packages+=(cabal)      # haskell package manager?
packages+=(nodejs)
packages+=(npm)
packages+=(rust)

packages+=(binutils) # gcc -pg -> ./a.out -> gprof ./a.out gmon.out
packages+=(clang)

## Compression/Encryption
packages+=(tar)
packages+=(zip)
packages+=(unzip)
packages+=(openssl)

## unixporn good looking
pip install $i --user
yaourt_packages+=(tty-clock)    # Clock in terminal
yaourt_packages+=(cava)         # Audio visualizer
packages+=(lolcat)              # rainbow colors
packages+=(neofetch)            # images of distro and specs
packages+=(feh)                 # set wallpaper
packages+=(python-pywal)        # colorchemes etc..

## Fonts
packages+=(powerline)           # cool font
packages+=(ttf-dejavu-sans-mono-powerline)
packages+=(ttf-dejavu)
yaourt_packages+=(nerd-fonts-complete)
yaourt_packages+=(nerd-fonts-dejavu-complete)
packages+=(nerd-fonts-terminus)
packages+=(noto-fonts)
packages+=(terminus-font)
packages+=(ttf-font-icons)

## Tools
packages+=(tldr)        # shorter man
packages+=(scrot)       #screenshots
packages+=(grep)
packages+=(blueman)     # bluetooth
packages+=(aspell)
packages+=(cloc)        # count lines of code
packages+=(ncdu)        # Disk uasge analyzer
packages+=(gnuplot)
packages+=(cower)       # used in polybar to check for updates

## Window manager
packages+=(i3-gaps)
#packages+=(i3status)
packages+=(i3status-manjaro)
packages+=(i3lock)       # lock screen
packages+=(polybar)
packages+=(rofi)
packages+=(xmonad)      # Use later :)
packages+=(xmonad-contrib)      # Use later :)
packages+=(xmobar)      # Use later :)

## Browser
yaourt_packages+=(google-chrome)
packages+=(firefox)

## PDF
packages+=(zathura)
packages+=(marked)

## pip stuff
pip_packages+=(Django)
pip_packages+=(matplotlib)
pip_packages+=(numpy)
pip_packages+=(pandas)
pip_packages+=(flake8)
pip_packages+=(neovim)

# ============== Install packages ===================
#sudo pacman-mirrors -g
sudo pacman -Syu --noconfirm
packages_string=""
for i in "${packages[@]}"; do
    packages_string="$packages_string $i"
    sudo pacman -S $i --noconfirm
done
#sudo pacman -S $packages_string

# Yaourt
git clone https://aur.archlinux.org/yaourt.git
cd yaourt/
makepkg -si

yaourt_packages_string=""
for i in "${yaourt_packages[@]}"; do
    yaourt_packages_string="$yaourt_packages_string $i"
    yaourt -S $i --noconfirm
done
#yaourt -S $yaourt_packages_string --noconfirm

# pip
pip_packages_string=""
for i in "${pip_packages[@]}"; do
    pip_packages_string="$pip_packages_string $i"
    # pip install $i --user
done
pip install $pip_packages_string --user

# ============== Other stuff ===================

## base16 colors
# https://github.com/chriskempson/base16-shell
#git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

## ------------- cp configs --------------------
#cp ~/dotfiles/.bashrc_WSL ~/.bashrc
cp ~/dotfiles/.bashrc ~/.bashrc
cp ~/dotfiles/.zshrc ~/.zshrc
cp ~/dotfiles/.profile ~/.profile

mkdir -p ~/.config/i3
cp ~/dotfiles/.config/i3/* ~/.config/i3/

mkdir -p ~/.config/i3status
cp ~/dotfiles/.config/i3status/* ~/.config/i3status/

mkdir -p ~/.config/polybar
cp ~/dotfiles/.config/polybar/* ~/.config/polybar/

cp ~/dotfiles/.Xresources ~/.Xresources
xrdb ~/.Xresources # load Xresources

## -------------  Setup nvim -------------------
### NVim plugin manager
## https://github.com/junegunn/vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip install --user --upgrade pynvim

mkdir -p ~/.config/nvim
cp ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
cp ~/dotfiles/.config/nvim/global_extra_conf.py ~/.config/nvim/global_extra_conf.py
cp ~/dotfiles/.config/nvim/readme.txt ~/.config/nvim/readme.txt

## Run :PlugInstall in nvim
nvim +'PlugInstall --sync' +qa

## ------------- Install youcompleteme ---------
#cd ~/.config/nvim/plugged/youcompleteme
#git submodule update --init --recursive
#python3 install.py --clang-completer
#python3 install.py --rust-completer
#python3 install.py --ts-completer
cd ~/tmp

## Virtualbox probably best manually because its kernel depended.
# sudo pacman -S virtualbox-guest-utils (in guest)
# xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
# xrandr --addmode Virtual1 1920x1080
# xrandr --output Virtual1 --mode 1920x1080

## --------------- OhMyZsh ------------------------
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
