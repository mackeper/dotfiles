#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Symlink zsh, tmux, git, and vim configs
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_ROOT/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_ROOT/.vimrc" "$HOME/.vimrc"

# Ensure .config directory exists
mkdir -p "$HOME/.config"

# Remove existing nvim config if it's a symlink or file
if [ -L "$HOME/.config/nvim" ] || [ -f "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
elif [ -d "$HOME/.config/nvim" ]; then
    echo "Warning: $HOME/.config/nvim is a directory. Please backup and remove it manually."
    exit 1
fi

# Create nvim symlink
ln -s "$DOTFILES_ROOT/nvim" "$HOME/.config/nvim"

echo "✓ Symlinked configs:"
echo "  - $SCRIPT_DIR/.zshrc -> $HOME/.zshrc"
echo "  - $SCRIPT_DIR/.tmux.conf -> $HOME/.tmux.conf"
echo "  - $DOTFILES_ROOT/.gitconfig -> $HOME/.gitconfig"
echo "  - $DOTFILES_ROOT/.vimrc -> $HOME/.vimrc"
echo "  - $DOTFILES_ROOT/nvim -> $HOME/.config/nvim"
