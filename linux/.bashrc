# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---- PATH ----
export PATH=$PATH:$HOME/bin               # Local bin scripts
export PATH=$PATH:$HOME/go/bin            # Go binaries
export PATH=$PATH:/usr/local/go/bin       # System Go
export PATH=$PATH:$HOME/dotnet            # .NET SDK

export DOTNET_ROOT=$HOME/dotnet

# ---- History ----
HISTCONTROL=ignoreboth                # Ignore duplicates and lines starting with space
shopt -s histappend                   # Append to history instead of overwriting
HISTSIZE=10000                        # Number of commands to remember in memory
HISTFILESIZE=20000                    # Number of lines to keep in history file
HISTTIMEFORMAT="%F %T "               # Format: YYYY-MM-DD HH:MM:SS
export HISTIGNORE="ls:ps:exit"       # Ignore these commands in history
bind '"\e[A": history-search-backward'    # Arrow up: search history with prefix
bind '"\e[B": history-search-forward'     # Arrow down: search history with prefix
bind '"\C-r": reverse-search-history'     # Ctrl+R: reverse search

# ---- Shell options ----
shopt -s globstar     # Enable ** for recursive globbing (e.g., ls **/*.txt)
shopt -s checkwinsize # Update LINES and COLUMNS after each command
shopt -s nocaseglob   # Case-insensitive glob matching

# ---- Prompt ----
# Get current git branch for prompt
parse_git_branch() {
    git branch --show-current 2>/dev/null | sed 's/ (.*//' | sed 's/.* //'
}

# Format: user:directory branch$
PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\]\$ '

# ---- Aliases ----
alias ls='eza --icons --group-directories-first' # Modern ls with icons
alias ll='eza -la --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'

eval "$(zoxide init bash)" # `z` instead of `cd`

# ---- Git ----
alias ga='git add'              # Add files
alias gd='git diff'             # Show changes
alias gdca='git diff --cached'  # Show cached changes
alias gl='git pull'             # Pull changes
alias gp='git push'             # Push changes
alias gst='git status'          # Show status
alias gc='git commit -v'        # Commit with verbose diff
alias gco='git checkout'        # Checkout branch
alias gb='git branch'           # List branches

# ---- fzf ----
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_COMMAND='fd --type f --hidden'     # Use fd (faster than find)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --max-depth 3'  # No hidden dirs

# ---- lazygit ----
bind -x '"\C-g": lazygit'

# ---- Editor ----
export EDITOR=nvim       # Default editor for git, etc.
export VISUAL=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
