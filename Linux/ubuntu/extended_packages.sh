#!/usr/bin/env bash

# List of packages for apt
apt_packages=(
    # Development
    "cmake" # Build system
    "dotnet-sdk-8.0"

    # Terminal tools
    "ddgr"     # DuckDuckGo from the terminal
    "lolcat"   # Rainbow text
    "neofetch" # System info

    # CTF / Security
    "exiftool" # Read and write meta information in files
    "hexyl"    # Hex viewer
    "nmap"     # Network scanner
    "steghide" # Hide data in files
    "openvpn"  # VPN
)

# List of packages for npm
npm_packages=(
    "wikit" # Terminal wikipedia
)

# List of packages for pip
pip_packages=()

# List of packages for go install
go_packages=(
    "github.com/boyter/scc/v3@latest" # Count lines of code
)

# List of packages for cargo install
cargo_packages=(
    # Terminal tools
    "du-dust"  # Disk usage
    "onefetch" # Neofetch for git repos
    "procs"    # Alternative to ps
)

custom_packages=(
    # Rust
    'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
    'source "$HOME/.cargo/env"'

    # Node https://github.com/nodesource/distributions?tab=readme-ov-file#ubuntu-versions
    'curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && sudo apt-get install -y nodejs'

    # Golang
    'wget -O ~/go.tar.gz https://go.dev/dl/go1.22.0.linux-amd64.tar.gz'
    'sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ~/go.tar.gz'
    'rm ~/go.tar.gz'
    'export PATH=$PATH:/usr/local/go/bin'

    # Haskell GHCup https://www.haskell.org/ghcup/
    'curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh'
)
