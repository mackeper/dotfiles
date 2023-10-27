bindkey -v
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Plugins MAKE SURE EXPORTS AND SOURCE are added after plugins
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
    npm
)

# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
# unsetopt LIST_BEEP

# Exports
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM=$ZSH/custom
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/rsa_id"
export KEYTIMEOUT=1
export VISUAL=vim
export EDITOR="$VISUAL"
# export FZF_BASE=/usr/bin/fzf

# Styling
ZSH_THEME="robbyrussell"
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"

# Some zsh settings
COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
DISABLE_MAGIC_FUNCTIONS="true"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source $ZSH/oh-my-zsh.sh

# Aliases
alias weather="wttr stockholm"

# Keybindings (global stuff)
# locate and capslock -> ctrl (set in i3/config)
setxkbmap -option ctrl:nocaps 
#setxkbmap -option caps:swapescape
setxkbmap -layout us -variant altgr-intl

# Write to WHEREAMI on every ENTER
#export PROMPT_COMMAND="pwd > /tmp/whereami"
precmd() { eval "$PROMPT_COMMAND" }
PROMPT_COMMAND="pwd > /tmp/whereami"

# History
setopt HIST_FIND_NO_DUPS    # Don't find duplicates on ctrl-r
setopt HIST_IGNORE_DUPS     # Don't add to hist if same as last one
setopt INC_APPEND_HISTORY   # Add lines to hist as soon as they are entered
setopt HIST_REDUCE_BLANKS   # Don't add superfluous blanks to hist
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
