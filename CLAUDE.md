# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Git Commit Guidelines

- Do NOT include Claude Code attribution or co-author credits in commit messages
- Keep commit messages concise and focused on the changes made

## Repository Overview

This is a multi-platform dotfiles repository supporting Linux (Ubuntu, Android/Termux), Windows, and macOS configurations. The primary focus is on terminal environments with vim/neovim, tmux, zsh, and git workflow optimizations.

## Directory Structure

- `linux/ubuntu/` - Ubuntu/Debian-based Linux configurations
- `linux/android/` - Termux (Android) specific configurations
- `nvim/` - Neovim configuration using Lua (lazy.nvim plugin manager)
- `windows/` - Windows PowerShell, AutoHotkey, and Windows Terminal configs
- `AutoHotkey/` - AutoHotkey scripts for Windows automation
- `scripts/` - Various utility scripts (media, PDF, yoga device scripts)
- `docker/` - Docker compose configurations (Home Assistant, Portainer)

## Platform-Specific Setup Scripts

### Ubuntu/Debian Linux

**Main installer:** `linux/ubuntu/install.sh`
- Downloads/updates dotfiles from GitHub: `https://github.com/mackeper/dotfiles`
- Options:
  - `-c` - Just setup configuration files (no package installation)
  - `-e` - Include extended/fun packages (neofetch, lolcat, etc.)
  - `-h` - Display help

**Installation from remote:**
```bash
curl -s https://raw.githubusercontent.com/mackeper/dotfiles/master/linux/ubuntu/install.sh | bash
```

**Package installation files:**
- `linux/ubuntu/minimal_packages.sh` - Core essential packages
- `linux/ubuntu/extended_packages.sh` - Optional fun/extra packages
- `linux/ubuntu/install_binaries.sh` - Binary installations (oh-my-posh, nvim, etc.)
- `linux/ubuntu/lib.sh` - Shared utility functions

**Symlinked configs:**
- `.tmux.conf` → `linux/ubuntu/.tmux.conf`
- `.zshrc` → `linux/ubuntu/.zshrc`
- `.config/nvim` → `nvim/`
- `.gitconfig` → `.gitconfig`

### Android/Termux

**Sequential setup scripts:**
1. `linux/android/01_install_essentials.sh` - Install core packages (coreutils, git, eza, fzf, ripgrep, fd, tmux)
2. `linux/android/02_install_font.sh` - Install Cascadia Code Nerd Font for terminal
3. `linux/android/03_symlink_configs.sh` - Create symlinks for .zshrc and .tmux.conf

**Symlinked configs:**
- `.zshrc` → `linux/android/.zshrc`
- `.tmux.conf` → `linux/android/.tmux.conf`

**Note:** Android configs may need nvim lazy.nvim concurrency adjustment (`concurrency = 5` in `nvim/lua/marcus/lazy.lua`)

### Windows

Located in `windows/` directory - contains PowerShell profiles, AutoHotkey scripts, installation scripts, and Windows Terminal configurations.

## Key Configuration Differences

### ZSH Configurations

**Ubuntu** (`linux/ubuntu/.zshrc`):
- Uses oh-my-posh or starship for prompt (conditionally loaded)
- Includes zoxide, carapace completions
- More extensive git aliases
- WSL-specific PATH additions when running under WSL

**Android** (`linux/android/.zshrc`):
- Custom git-aware prompt function (no oh-my-posh/starship)
- Simpler plugin set via zap plugin manager
- Minimal aliases focused on essential workflow

**Both share:**
- Zap plugin manager with zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting, fzf integration
- Vi mode with visual cursor changes
- Vim text objects support
- FZF directory navigation (Ctrl+P)
- Lazygit binding (Ctrl+G)
- Extensive git aliases
- DOTNET_ROOT and PATH configurations for Go, .NET, Mason (nvim)

### Tmux Configuration

Located in `linux/android/.tmux.conf` (likely shared/symlinked to ubuntu as well):
- Prefix: `Ctrl+a` (unbinds default Ctrl+b)
- Split panes: prefix + `v` (horizontal), prefix + `h` (vertical)
- Vim-tmux-navigator integration for seamless pane navigation
- Plugins via TPM (tpm, tmux-sensible, tmux-which-key, tmux-resurrect, tmux-continuum)
- Vi copy mode with vim-style keybindings
- Custom status line with git branch awareness
- Mouse support enabled

**Cheatsheet reference in file:**
- prefix + space: which-key menu
- prefix + c: create new window
- prefix + n/p: next/previous window
- prefix + s: session menu
- prefix + $: rename session

## Neovim Configuration

Located in `nvim/` directory:
- Entry point: `nvim/init.lua` → requires `marcus` module
- Uses lazy.nvim plugin manager (`nvim/lua/marcus/lazy.lua`)
- Configuration organized in `nvim/lua/marcus/` directory
- Modular plugin setup in `nvim/lua/marcus/plugins/`
- Scripts for installation in `nvim/scripts/`

When modifying nvim configs, always edit files in the `nvim/lua/marcus/` directory tree.

## Git Configuration

`.gitconfig` uses:
- Delta as pager with line numbers and navigation
- nvim/nvimdiff as merge tool
- diff3 conflict style
- Default branch: main
- Shows untracked files, branch status, and stash in status

## Common Development Workflows

### Testing ZSH config changes
After modifying `.zshrc` files, either:
- Reload shell: `exec zsh` or `source ~/.zshrc`
- Test in new shell: `zsh`

### Testing Tmux config changes
After modifying `.tmux.conf`:
- Reload: prefix + `r` (bound to `source-file ~/.tmux.conf`)

### Symlink creation pattern
Most setup scripts use:
```bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ln -sf "$SCRIPT_DIR/.config_file" "$HOME/.config_file"
```

### Package installation pattern
Uses functions from `lib.sh`:
- `check_requirements` - Validates required commands exist
- `install_packages_from_source` - Installs from package list files
- `echo_title`, `echo_info`, `echo_debug` - Formatted output functions

## Important Conventions

1. **Symlinks over copies:** Configs are symlinked to repository locations, not copied
2. **Platform separation:** Keep platform-specific configs in their respective directories
3. **Minimal duplication:** Shared configs reference common files where possible
4. **Bootstrap-friendly:** Install scripts can be curled and executed remotely
5. **Plugin managers:** Use native package managers (zap for zsh, TPM for tmux, lazy.nvim for neovim)
6. **Vi-mode everywhere:** ZSH, tmux copy mode, and nvim all use vi keybindings

## Current Work Context

Recent commits show organization and Android/Termux setup work. Staged changes include new Android setup scripts and configuration files, indicating active development on the Termux environment setup.
