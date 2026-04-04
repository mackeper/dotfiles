#!/bin/bash
set -e

DOTFILES=~/git/dotfiles/opencode
CONFIG=~/.config/opencode

ln -s "$DOTFILES/AGENTS.md" "$CONFIG/AGENTS.md"
ln -s "$DOTFILES/commands" "$CONFIG/commands"
ln -s "$DOTFILES/skills" "$CONFIG/skills"
