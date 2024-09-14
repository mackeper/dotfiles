#!/usr/bin/env bash

# List of packages for apt
apt_packages=(
    # Terminal tools

    # Development
    "cmake" # Build system
    "dotnet-sdk-8.0"

    # CTF / Security
    "openvpn" # VPN
)

# List of packages for npm
npm_packages=()

# List of packages for pip
pip_packages=(
    # Terminal tools
    # "thefuck"
    # "yt-dlp" # Youtube downloader

    # CTF / Security
    # "flask-unsign"

    # Development
)

# List of packages for go install
go_packages=(
    "github.com/boyter/scc/v3@latest" # Count lines of code
)

# List of packages for cargo install
cargo_packages=()

custom_packages=(
    # Zsh / Zap
    'chsh -s $(which zsh)'
    'zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep'

    # Oh My Posh
    'curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin'

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

    # gh https://cli.github.com/
    # BROWSER=false gh auth login
    # sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    # && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    # && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    # && sudo apt update \
    # && sudo apt install gh -y
)
