#!/bin/bash

# List of packages for apt
apt_packages=(
    # "procs"
    # Essential
    "build-essential" # Build tools
    "git" # Version control
    "unzip" # Unzip files

    # Terminal tools
    "bat" # Alternative to cat, alias bat="batcat"
    "btop" # Resource monitor
    "ddgr" # DuckDuckGo from the terminal
    "eza" # Easy alias, alias ls="eza --icons"; alias ll="eza --icons -la", etc.
    "fd-find" # Alternative to find, alias fd="fdfind"
    "fzf" # Fuzzy finder
    "lolcat" # Rainbow text
    "neofetch" # System info
    "ripgrep" # Alternative to grep, command rg
    "zoxide" # Alternative to cd, alias z="zoxide"

    # Development
    "cmake" # Build system

    # CTF / Security
    "exiftool" # Read and write meta information in files
    "hexyl" # Hex viewer
    "nmap" # Network scanner
    "steghide" # Hide data in files
)

# List of packages for npm
npm_packages=(
    "wikit" # Terminal wikipedia
)

# List of packages for pip
pip_packages=(
    # Terminal tools
    "thefuck"
    "youtube-dl"

    # CTF / Security
    "flask-unsign"
)

# List of packages for go install
go_packages=(
    "github.com/boyter/scc/v3@latests" # Count lines of code
)

# List of packages for cargo install
cargo_packages=(
    # Terminal tools
    "du-dust" # Disk usage
    "onefetch" # Neofetch for git repos
    "git-delta" # Better git diffs
)

# Function to concatenate packages into strings
concatenate_packages() {
    local packages=("$@")
    local concatenated=""
    for package in "${packages[@]}"; do
        concatenated+=" $package"
    done
}

# Concatenate packages for each package manager
apt_string=$(concatenate_packages "${apt_packages[@]}")
npm_string=$(concatenate_packages "${npm_packages[@]}")
pip_string=$(concatenate_packages "${pip_packages[@]}")
go_string=$(concatenate_packages "${go_packages[@]}")
cargo_string=$(concatenate_packages "${cargo_packages[@]}")

# Print the concatenated strings
echo "APT packages: $apt_string"
echo "NPM packages: $npm_string"
echo "PIP packages: $pip_string"
echo "GO packages: $go_string"
echo "Cargo packages: $cargo_string"
