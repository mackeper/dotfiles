#!/usr/bin/env bash

dnf_packages=(
    # Essential
    "@c-development"
    "@development-tools"
    "git"
    "unzip"
    "fuse"
    "fuse-devel"
    "curl"
    "wget"
    "openssl"
    "sudo"
    "tmux"
    "net-tools"
    "xclip"

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
    "vim"
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
        sudo dnf install -y "$package"
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
