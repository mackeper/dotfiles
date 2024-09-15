#!/usr/bin/env bash

STATIC_REPO_PATH="https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu"
LOCAL_REPO_PATH="$HOME/git/dotfiles"
SCRIPTS_PATH="$LOCAL_REPO_PATH/linux/ubuntu"
MINIMAL_PACKAGES_PATH="$SCRIPTS_PATH/minimal_packages.sh"
EXTENDED_PACKAGES_PATH="$SCRIPTS_PATH/extended_packages.sh"
LIB_PATH="$SCRIPTS_PATH/lib.sh"
BINARIES_PATH="$SCRIPTS_PATH/install_binaries.sh"
just_configs=false
include_extended_packages=false

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

while getopts ":hcf:" option; do
    case $option in
    h)
        help
        exit
        ;;
    c)
        just_configs=true
        ;;
    e)
        include_extended_packages=true
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
        return 0
    fi

    echo_title "Downloading dotfiles"
    mkdir -p ~/git
    git clone https://github.com/mackeper/dotfiles.git "$LOCAL_REPO_PATH"
    return 0
}

copy_configs() {
    commands=(
        'ln -sf "$LOCAL_REPO_PATH/linux/ubuntu/.tmux.conf" ~/.tmux.conf'
        'ln -sf "$LOCAL_REPO_PATH/linux/ubuntu/.zshrc" ~/.zshrc'
        'mkdir -p ~/.config'
        'ln -sf "$LOCAL_REPO_PATH/nvim" ~/.config/nvim'
        'ln -sf "$LOCAL_REPO_PATH/.gitconfig" ~/.gitconfig'
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

    echo_info "Sourcing $LIB_PATH"
    source $LIB_PATH

    echo_debug "Just configs: $just_configs"
    if [ $just_configs = true ]; then
        copy_configs
        exit 0
    fi

    echo_info "Installing packages $MINIMAL_PACKAGES_PATH"
    install_packages_from_source "$MINIMAL_PACKAGES_PATH" || exit 1

    if [ $include_extended_packages = true ]; then
        install_packages_from_source "$EXTENDED_PACKAGES_PATH" || exit 1
    fi

    copy_configs

    source $BINARIES_PATH
}

main
