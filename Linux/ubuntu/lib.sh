echo_title() {
    echo -e "\n\033[30;44m $1 \033[0m"
}

echo_error() {
    echo -e "\033[31m[ error ] $1\033[0m"
}

echo_warning() {
    echo -e "\033[33m[ warning ] $1\033[0m"
}

echo_info() {
    echo -e "\033[34m[ info ] $1\033[0m"
}

echo_debug() {
    echo -e "\033[32m[ debug ] $1\033[0m"
}

# Check if requirements are installed
# Usage: check_requirements $check_requirements
check_requirements() {
    echo_title "Checking requirements"
    if [ -z "$1" ]; then
        echo_error "Missing requirements argument"
        return 1
    fi
    requirements=$1
    missing_requirements=()

    for requirement in "${requirements[@]}"; do
        if ! command -v $requirement &>/dev/null; then
            missing_requirements+=($requirement)
        fi
    done

    if [ ${#missing_requirements[@]} -ne 0 ]; then
        echo_error "Missing requirements: ${missing_requirements[@]}"
        return 1
    fi
    return 0
}

# Install install packages
# Usage:
#     install_packages "sudo npm -g install" "${npm_packages[@]}"
#     install_packages "pip install" "${pip_packages[@]}"
#     install_packages "go install" "${go_packages[@]}"
#     install_packages "cargo install" "${cargo_packages[@]}"
install_packages() {
    echo_title "Installing packages"
    if [ -z "$1" ]; then
        echo_error "Missing install command"
        return 1
    fi
    if [ -z "$2" ]; then
        echo_error "Missing packages"
        return 1
    fi
    local packages=("$@")
    local concatenated="$1"
    for package in "${packages[@]:1}"; do
        concatenated+=" $package"
    done
    echo_info "$concatenated"
    $concatenated
}

install_packages_from_source() {
    echo_title "Installing packages from source"
    if [ -z "$1" ]; then
        echo_error "Missing source argument"
        return 1
    fi

    echo_info "Sourcing $1"
    source <(curl -s "$1")

    # Update and upgrade
    echo_title "APT"
    sudo apt update
    sudo apt upgrade -y
    install_packages "sudo apt install -y " "${apt_packages[@]}" # Required before installing other packages

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
    return 0
}
