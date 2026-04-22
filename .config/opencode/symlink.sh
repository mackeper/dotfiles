#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config/opencode"

ln -sf "$SCRIPT_DIR/AGENTS.md" "$CONFIG/AGENTS.md"
ln -sf "$SCRIPT_DIR/commands" "$CONFIG/commands"
ln -sf "$SCRIPT_DIR/skills" "$CONFIG/skills"
ln -sf "$SCRIPT_DIR/agents" "$CONFIG/agents"
ln -sf "$SCRIPT_DIR/opencode.json" "$CONFIG/opencode.json"
