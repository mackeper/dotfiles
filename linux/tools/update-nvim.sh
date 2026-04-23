#!/usr/bin/env bash
set -e

check_deps() {
    for cmd in curl jq tar; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Error: $cmd is required but not installed."
            exit 1
        fi
    done
}

check_deps

ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ASSET_NAME="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) ASSET_NAME="nvim-linux-arm64.tar.gz" ;;
    *) echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
esac

VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')
echo "Latest Neovim version: $VERSION"
read -p "Proceed with download? [y/N] " confirm
[[ "$confirm" != "y" ]] && echo "Aborted." && exit

mkdir -p ~/bin

ASSET_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
    jq -r ".assets[] | select(.name == \"$ASSET_NAME\") | .browser_download_url")

curl -fsSL "$ASSET_URL" -o /tmp/nvim.tar.gz
tar -xzf /tmp/nvim.tar.gz -C ~/bin
rm /tmp/nvim.tar.gz

FOLDER_NAME="${ASSET_NAME%.tar.gz}"

rm -f ~/bin/nvim
ln -s ~/bin/"$FOLDER_NAME"/bin/nvim ~/bin/nvim

echo "Neovim extracted to ~/bin/$FOLDER_NAME"
echo "Symlink created: ~/bin/nvim -> ~/bin/$FOLDER_NAME/bin/nvim"