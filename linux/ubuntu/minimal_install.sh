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
    "sudo"
    "tmux"
    "net-tools"
    "xclip"
    "libffi-dev"
    "libffi8ubuntu1"
    "libgmp-dev"
    "libgmp10"
    "libncurses-dev"
    "libncurses5"
    "libtinfo5"

    # Terminal tools
    "fzf"
    "ripgrep"
    "zoxide"
    "bat"
    "btop"
    "fd-find"
    "jq"
    "delta"
    "tree"
    "eza"

    # Development
    "make"
    "python3"
    "python3-pip"
    "python3-venv"
)

pip_packages=(
    # Development
    "pynvim"
)

for package in "${apt_packages[@]}"; do
    if ! dpkg -l "$package" >/dev/null 2>&1; then
        echo "Installing $package..."
        sudo apt-get install -y "$package"
    else
        echo "$package already installed"
    fi
done

for package in "${pip_packages[@]}"; do
    if ! pip3 show "$package" >/dev/null 2>&1; then
        echo "Installing pip package $package..."
        pip3 install "$package"
    else
        echo "pip package $package already installed"
    fi
done
