function echo_title() {
    echo -e "\n\033[30;44m $1 \033[0m"
}

function echo_error() {
    echo -e "\033[31m[ error ] $1\033[0m"
}

function echo_warning() {
    echo -e "\033[33m[ warning ] $1\033[0m"
}

function echo_info() {
    echo -e "\033[32m[ info ] $1\033[0m"
}

# Check if requirements are installed
# Usage: check_requirements $check_requirements
function check_requirements() {
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
