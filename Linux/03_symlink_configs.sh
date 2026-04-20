#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ensure .config directory exists
mkdir -p "$HOME/.config"

# Symlink config
ln -sf "$DOTFILES_ROOT/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_ROOT/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_ROOT/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_ROOT/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_ROOT/.gitconfig" "$HOME/.gitconfig"

# Remove existing nvim config if it's a symlink or file
if [ -L "$HOME/.config/nvim" ] || [ -f "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
elif [ -d "$HOME/.config/nvim" ]; then
    echo "Warning: $HOME/.config/nvim is a directory. Please backup and remove it manually."
    exit 1
fi
ln -s "$DOTFILES_ROOT/.config/nvim" "$HOME/.config/nvim"

