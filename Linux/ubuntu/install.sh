#!/usr/bin/env bash

STATIC_REPO_PATH="https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu"
LOCAL_REPO_PATH="$HOME/git/dotfiles"
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

while getopts ":hcf:" option; do
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

    echo_debug "Just configs: $just_configs"
    if [ $just_configs = true ]; then
        copy_configs
        exit 0
    fi

    echo_info "Installing packages $STATIC_REPO_PATH/minimal_packages.sh"
    install_packages_from_source "$STATIC_REPO_PATH/minimal_packages.sh" || exit 1

    if [ $include_fun_packages = true ]; then
        install_packages_from_source $STATIC_REPO_PATH/fun_packages.sh
    fi

    copy_configs
}

main
