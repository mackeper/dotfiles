#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source $SCRIPT_DIR/lib.sh

requirements=(
    "git"
)

function download_dotfiles() {
    if [ -d ~/git/dotfiles ]; then
        echo_title "Updating dotfiles"
        cd ~/git/dotfiles
        git pull
        cd -
        return
    fi

    echo_title "Downloading dotfiles"
    mkdir -p ~/git
    git config --global user.email "mpt.ostling@gmail.com"
    git config --global user.name "Marcus Östling"
    git clone https://github.com/mackeper/dotfiles.git ~/git/dotfiles
}

function install_essential_packages() {
    source $SCRIPT_DIR/essential_packages.sh
    # Update and upgrade
    echo_title "APT"
    sudo apt update
    sudo apt upgrade -y
    install_packages "sudo apt install" "${apt_packages[@]}" # Required before installing other packages

    # Custom commands
    echo_title "Custom commands"
    for command in "${custom_packages[@]}"; do
        echo_info "$command"
        eval $command
    done

    # Upgrade pip
    echo_title "Upgrade pip"
    pip install --upgrade pip

    # Install packages for each package manager
    install_packages "sudo npm -g install" "${npm_packages[@]}"
    install_packages "pip install" "${pip_packages[@]}"
    install_packages "go install" "${go_packages[@]}"
    install_packages "cargo install" "${cargo_packages[@]}"
}

function install_fun_packages() {
    source $SCRIPT_DIR/fun_packages.sh

    # Custom commands
    echo_title "Custom commands"
    for command in "${custom_packages[@]}"; do
        echo_info "$command"
        eval $command
    done

    # Install packages for each package manager
    install_packages "sudo apt install" "${apt_packages[@]}"
    install_packages "sudo npm -g install" "${npm_packages[@]}"
    install_packages "pip install" "${pip_packages[@]}"
    install_packages "go install" "${go_packages[@]}"
    install_packages "cargo install" "${cargo_packages[@]}"
}

function main() {
    check_requirements $requirements || exit 1
    download_dotfiles
    install_essential_packages
}

main
