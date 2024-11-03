#!/usr/bin/env bash
apt_packages=(
    # Essential
    "build-essential"
    "git"
    "unzip"
    "fuse"
    "libfuse2"
    "curl"
    "wget"
    "openssl"
    "tmux"
    "xclip"
    "libffi-dev"
    "libffi8ubuntu1"
    "libgmp-dev"
    "libgmp10"
    "libncurses-dev"
    "libncurses5"
    "libtinfo5"

    # Terminal
    "zsh"

    # Terminal tool[ -x "$(command -v zap)" ]s
    "fzf"     # Fuzzy finder
    "ripgrep" # Alternative to grep, command rg
    "zoxide"  # Alternative to cd, alias z="zoxide"
    "bat"     # Alternative to cat, alias bat="batcat"
    "btop"    # Resource monitor
    "fd-find" # Alternative to find, alias fd="fdfind"
    "jq"      # JSON processor

    # Development
    "make" # Build system
    "python3"
    "python3-pip"
    "python3-venv"
)

# List of packages for pip
pip_packages=(
    # Development
    "pynvim" # Neovim support
)

custom_packages=(
    # Zsh / Zap
    '[[ "$SHELL" == *"zsh"* ]] || chsh -s $(which zsh)'
    '[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ] || zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep'

    # Oh My Posh
    '[ -f "$HOME/bin/oh-my-posh" ] || [ -f "$HOME/.local/bin/oh-my-posh" ] || curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin'
)
