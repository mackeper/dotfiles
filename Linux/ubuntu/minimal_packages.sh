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
