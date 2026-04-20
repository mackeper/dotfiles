#!/bin/bash
set -e

DOTFILES=~/git/dotfiles/.config/opencode
CONFIG=~/.config/opencode

ln -sf "$DOTFILES/AGENTS.md" "$CONFIG/AGENTS.md"
ln -sf "$DOTFILES/commands" "$CONFIG/commands"
ln -sf "$DOTFILES/skills" "$CONFIG/skills"
ln -sf "$DOTFILES/agents" "$CONFIG/agents"
