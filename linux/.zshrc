[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"

[ -f .env ] && source .env

prompt_git() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    git diff --quiet 2>/dev/null
    has_diff=$?
    git diff --cached --quiet 2>/dev/null
    has_staged=$?
    [[ $has_diff -ne 0 || $has_staged -ne 0 ]] && dirty="%F{9}~%f" || dirty=""
    print -P " (%F{10}${branch}${dirty}%F{15})"
}
setopt promptsubst
PROMPT='%F{10}Z%f %F{15}%~$(prompt_git)%f
> '

# ---- Load and initialise completion system ----
autoload -U +X bashcompinit && bashcompinit # some tools only provide bash completion   
autoload -Uz compinit; compinit
zstyle ':autocomplete:*' default-context history-incremental-search-backward
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' delay 0.1
zstyle ':autocomplete:*:*' list-lines 5
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# ---- nvim something fix ----
# https://github.com/nvim-lua/plenary.nvim/issues/536
export XDG_RUNTIME_DIR=/tmp

# ---- Add local bin ----
export PATH=$PATH:~/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/.dotnet/tools
export PATH=$PATH:$HOME/dotnet
export PATH=$PATH:$HOME/.local/share/nvim/mason/bin

export DOTNET_ROOT=$HOME/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if uname -r |grep -q 'microsoft' ; then
    export PATH=$PATH:/mnt/c/Windows
    export PATH=$PATH:/mnt/c/Windows/System32
    export PATH=$PATH:/mnt/c/ProgramData/chocolatey/bin
    export PATH=$PATH:"/mnt/c/Program Files/WindowsApps/Microsoft.PowerShell_7.4.6.0_x64__8wekyb3d8bbwe"

    function powershell() {
        pwsh.exe -NoExit -c 'cd $env:userprofile'
    }
fi

# ---- Vim ----
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'

bindkey -v
export KEYTIMEOUT=1

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ---- Tools ----
# FZF
export FZF_DEFAULT_OPTS="--preview '[[ -f {} ]] && batcat -n --color=always {} || eza --icons --color=always --tree --level=1 {}'"
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!.git"'

function fzf-cd() {
  local locations=(
    "$HOME/git"
    "$HOME"
  )

  local dirs=()
  for loc in "${locations[@]}"; do
    [[ -d "$loc" ]] && dirs+=($(find "$loc" -mindepth 1 -maxdepth 1 -type d 2>/dev/null))
  done

  local dest=$(printf '%s\n' "${dirs[@]}" | fzf)
  [[ -n "$dest" ]] && cd "$dest"
}

bindkey -s '^P' 'fzf-cd\n'

# aliases
function wttr() { curl "wttr.in/$1"; }
alias wttrs='curl wttr.in/stockholm'
function cht() { curl "cht.sh/$1"; }

alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --level=3 --icons'

# ---- Turn off all beeps ----
unsetopt BEEP

# ---- Bindkeys ----
lazygit_func () { eval 'lazygit' }
zle -N lazygit_func
bindkey '^G' lazygit_func

# ---- History ----
setopt HIST_FIND_NO_DUPS    # Don't find duplicates on ctrl-r
setopt HIST_IGNORE_DUPS     # Don't add to hist if same as last one
setopt INC_APPEND_HISTORY   # Add lines to hist as soon as they are entered
setopt HIST_REDUCE_BLANKS   # Don't add superfluous blanks to hist
setopt appendhistory
setopt hist_ignore_space
setopt sharehistory
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase

# ---- Git aliases ----
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gau='git add -u'
alias gb='git branch'
alias gc='git commit -ev'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git checkout $(git rev-parse --verify master 2>/dev/null || echo "main")'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdss='git diff --shortstat'
alias gg='git grep -n'
function ggwt() { git grep -n "$1" -- "${2:-*.cs}" ":!*Fixture*" ":!*Test*"; }
alias gl='git pull'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gp='git push'
alias gpn='git push --set-upstream origin $(git branch --show-current)'
alias grs='git restore'
alias grss='git restore --staged'
alias gst='git status'
