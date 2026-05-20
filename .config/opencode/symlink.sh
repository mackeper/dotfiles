#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config/opencode"

# Remove existing symlinks in CONFIG (prevent ln -sf placing inside resolved dir)
for item in AGENTS.md commands skills agents opencode.json; do
  target="$CONFIG/$item"
  if [ -L "$target" ]; then
    rm "$target"
  fi
done

# Remove circular symlinks from source dirs
for dir in skills agents commands; do
  circular="$SCRIPT_DIR/$dir/$dir"
  if [ -L "$circular" ]; then
    rm "$circular"
  fi
done

ln -s "$SCRIPT_DIR/AGENTS.md" "$CONFIG/AGENTS.md"
ln -s "$SCRIPT_DIR/commands" "$CONFIG/commands"
ln -s "$SCRIPT_DIR/skills" "$CONFIG/skills"
ln -s "$SCRIPT_DIR/agents" "$CONFIG/agents"
ln -s "$SCRIPT_DIR/opencode.json" "$CONFIG/opencode.json"
