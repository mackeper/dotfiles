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

    # Terminal tools
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
    "lazygit"
)

# List of packages for pip
pip_packages=(
    # Development
    "pynvim" # Neovim support
)

custom_packages=(
    # Zsh / Zap
    'chsh -s $(which zsh)'
    'zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep'

    # Oh My Posh
    'curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin'
)
