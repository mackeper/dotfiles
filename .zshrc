# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100
SAVEHIST=100
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/macke/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# https://github.com/chriskempson/base16-shell
# Base16 Shell
# Usage: base16_ <tab> auto complete
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
        [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
                eval "$("$BASE16_SHELL/profile_helper.sh")"
