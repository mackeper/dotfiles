# ---- Created by Zap installer ----
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "Aloxaf/fzf-tab"
plug "zap-zsh/fzf"

# ---- Load and initialise completion system ----
autoload -Uz compinit
compinit

# ---- nvim something fix ----
# https://github.com/nvim-lua/plenary.nvim/issues/536
export XDG_RUNTIME_DIR=/tmp

# ---- Add local bin ----
export PATH=$PATH:~/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/.dotnet/tools

if uname -r |grep -q 'microsoft' ; then
    export PATH=$PATH:/mnt/c/Windows
    export PATH=$PATH:/mnt/c/Windows/System32
    export PATH=$PATH:/mnt/c/ProgramData/chocolatey/bin
    export PATH=$PATH:"/mnt/c/Program Files/PowerShell/7"

    function powershell() {
        pwsh.exe -NoExit -c 'cd $env:userprofile'
    }
fi

# ---- Auto tmux ----
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi

# ---- Tools ----
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '~/bin/themes/tokyonight_storm.omp.json')"
  # eval "$(starship init zsh)"
fi

# eval $(thefuck --alias)
eval "$(zoxide init zsh)"

# FZF
# export FZF_DEFAULT_OPTS="--preview 'batcat -n --color=always {}'"
export FZF_DEFAULT_OPTS="--preview '[[ -f {} ]] && batcat -n --color=always {} || eza --icons --color=always --tree --level=1 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:wrap"

# aliases
function wttr() { curl "wttr.in/$1"; }
alias wttrs='curl wttr.in/stockholm'
function cht() { curl "cht.sh/$1"; }

alias bat='batcat'
alias fd='fdfind'
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --level=3 --icons'
alias python='python3'

# ---- Turn off all beeps ----
unsetopt BEEP

# ---- Keymaps ----
# setxkbmap -option ctrl:nocaps
# setxkbmap -layout us -variant altgr-intl

# ---- Bindkeys ----
lazygit_func () { eval 'lazygit' }
zle -N lazygit_func
bindkey '^G' lazygit_func

# ---- History ----
setopt HIST_FIND_NO_DUPS    # Don't find duplicates on ctrl-r
setopt HIST_IGNORE_DUPS     # Don't add to hist if same as last one
setopt INC_APPEND_HISTORY   # Add lines to hist as soon as they are entered
setopt HIST_REDUCE_BLANKS   # Don't add superfluous blanks to hist
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# ---- Git aliases ----
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gau='git add -u'
alias gb='git branch'
alias gbr='git branch --remote'
alias gbl='git blame -b -w'
alias gc='git commit -ev'
alias gc!='git commit -ev --amend'
alias gclean='git clean -fX'
alias gcleanvs='git clean -fX -e !.vs'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git checkout $(git rev-parse --verify master 2>/dev/null || echo "main")'
alias gcl='git checkout -'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gdss='git diff --shortstat'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gg='git grep -n'
function ggwt() { git grep -n "$1" -- "${2:-*.cs}" ":!*Fixture*" ":!*Test*"; }
alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --stat'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gm='git merge'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gp='git push'
alias gpn='git push --set-upstream origin $(git branch --show-current)'
alias greh='git reset'
alias grm='git rm'
alias grmc='git rm --cached'
alias grs='git restore'
alias grss='git restore --staged'
alias gss='git status -s'
alias gst='git status'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='git stash --include-untracked'
alias gstall='git stash --all'


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/marcus/.opam/opam-init/init.zsh' ]] || source '/home/marcus/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
