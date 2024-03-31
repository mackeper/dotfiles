#!/usr/bin/env bash

function echo_title() {
    echo -e "\n\033[37;44m $1\033[0m"
}

# List of packages for apt
apt_packages=(
    # Essential
    "build-essential"
    "git"
    "unzip"
    "fuse"
    "libfuse2"
    "curl"
    "wget"
    "openssl"
    "tmux"
    "xclip"
    "libffi-dev"
    "libffi8ubuntu1"
    "libgmp-dev"
    "libgmp10"
    "libncurses-dev"
    "libncurses5"
    "libtinfo5"

    # Terminal
    "zsh"

    # Terminal tools
    "bat" # Alternative to cat, alias bat="batcat"
    "btop" # Resource monitor
    "duf" # Disk usage
    "ddgr" # DuckDuckGo from the terminal
    "fd-find" # Alternative to find, alias fd="fdfind"
    "fzf" # Fuzzy finder
    "lolcat" # Rainbow text
    "neofetch" # System info
    "ripgrep" # Alternative to grep, command rg
    "zoxide" # Alternative to cd, alias z="zoxide"
    "jq" # JSON processor

    # Development
    "cmake" # Build system
    "make" # Build system
    "python3"
    "python3-pip"
    "python3-venv"
    "dotnet-sdk-8.0"

    # CTF / Security
    "exiftool" # Read and write meta information in files
    "hexyl" # Hex viewer
    "nmap" # Network scanner
    "steghide" # Hide data in files
    "openvpn" # VPN
)

# List of packages for npm
npm_packages=(
    "wikit" # Terminal wikipedia
)

# List of packages for pip
pip_packages=(
    # Terminal tools
    # "thefuck"
    # "yt-dlp" # Youtube downloader

    # CTF / Security
    "flask-unsign"

    # Development
    "pynvim" # Neovim support
)

# List of packages for go install
go_packages=(
    "github.com/boyter/scc/v3@latest" # Count lines of code
)

# List of packages for cargo install
cargo_packages=(
    # Terminal tools
    "du-dust" # Disk usage
    "onefetch" # Neofetch for git repos
    "git-delta" # Better git diffs
    "procs" # Alternative to ps
    "eza" # Easy alias, alias ls="eza --icons"; alias ll="eza --icons -la", etc.
    "cargo-nextest" # Rust test runner used by neotest-rust
)

custom_packages=(
    # Nvim
    'mkdir ~/bin && wget -O ~/bin/nvim https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage && chmod u+x ~/bin/nvim'

    # Zoxide
    "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"

    # Lazygit
    'LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"'"'"tag_name": "v\K[^"]*'"'"')'
    'curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"'
    "tar xf lazygit.tar.gz lazygit"
    "sudo install lazygit /usr/local/bin"
    "rm lazygit lazygit.tar.gz"

    # Zsh
    'chsh -s $(which zsh)'
    'zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1'

    # Oh My Posh
    'curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin'

    # Rust
    'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh'
    'source "$HOME/.cargo/env"'

    # Node https://github.com/nodesource/distributions?tab=readme-ov-file#ubuntu-versions
    'curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && sudo apt-get install -y nodejs'

    # Golang
    'wget -O ~/go.tar.gz https://go.dev/dl/go1.22.0.linux-amd64.tar.gz'
    'sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ~/go.tar.gz'
    'rm ~/go.tar.gz'
    'export PATH=$PATH:/usr/local/go/bin'

    # Haskell GHCup https://www.haskell.org/ghcup/
    'curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh'

    # gh https://cli.github.com/
    # BROWSER=false gh auth login
    # sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    # && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    # && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    # && sudo apt update \
    # && sudo apt install gh -y
)

# Function to concatenate packages into strings
install_packages() {
    local packages=("$@")
    local concatenated="$1"
    for package in "${packages[@]:1}"; do
        concatenated+=" $package"
    done
    echo_title "$concatenated"
    $concatenated
}

# Update and upgrade
echo_title "APT"
sudo apt update
sudo apt upgrade -y
install_packages "sudo apt install" "${apt_packages[@]}" # Required before installing other packages

# Custom commands
echo_title "Custom commands"
for command in "${custom_packages[@]}"; do
    echo -e "\033[34m $command\033[0m"
    eval $command
done

echo_title "pip"
pip install --upgrade pip

# Install packages for each package manager
install_packages "sudo npm -g install" "${npm_packages[@]}"
install_packages "pip install" "${pip_packages[@]}"
install_packages "go install" "${go_packages[@]}"
install_packages "cargo install" "${cargo_packages[@]}"
