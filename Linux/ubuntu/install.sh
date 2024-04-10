#!/usr/bin/env bash

STATIC_REPO_PATH="https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu"
LOCAL_REPO_PATH="~/git/dotfiles"
just_configs=false
include_fun_packages=false

source <(curl -s $STATIC_REPO_PATH/lib.sh)

requirements=(
    "git"
)

help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h  Display help"
    echo "  -c  Just setup the configuration files"
    echo "  -f  Include fun packages"
}

while getopts ":hc:" option; do
    case $option in
    h)
        help
        exit
        ;;
    c)
        just_configs=true
        ;;
    f)
        include_fun_packages=true
        ;;
    \?) # Invalid option
        echo "Invalid option command line option. Use -h for help."
        exit 1
        ;;
    esac
done

download_dotfiles() {
    if [ -d ~/git/dotfiles ]; then
        echo_title "Updating dotfiles"
        cd ~/git/dotfiles
        git pull
        cd -
        return 1
    fi

    echo_title "Downloading dotfiles"
    mkdir -p ~/git
    git clone https://github.com/mackeper/dotfiles.git "$LOCAL_REPO_PATH"
    return 0
}

copy_configs() {
    commands=(
        'ln -sf $local_repo_path/linux/ubuntu/.tmux.conf ~/.tmux.conf'
        'ln -sf $local_repo_path/linux/ubuntu/.zshrc ~/.zshrc'
        'ln -sf $local_repo_path/nvim ~/.config/nvim'
        'ln -sf $local_repo_path/.gitconfig ~/.gitconfig'
    )

    echo_title "Copying configs"
    for command in "${commands[@]}"; do
        echo_info "$command"
        eval $command
    done
}

main() {
    check_requirements $requirements || exit 1
    download_dotfiles || exit 1

    if [ $just_configs = true ]; then
        copy_configs
        exit 0
    fi

    install_packages_from_source $STATIC_REPO_PATH/essential_packages.sh

    if [ $include_fun_packages = true ]; then
        install_packages_from_source $STATIC_REPO_PATH/fun_packages.sh
    fi

    copy_configs
}

main
