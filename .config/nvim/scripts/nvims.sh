#!/usr/bin/env zsh
# Inspired by: https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b

function nvims() {
  config_dir=~/.config/nvim_configs
  items=("default")
  items+=($(ls -d $config_dir/*/ | xargs -n 1 basename))
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border --exit-0 --no-preview)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    NVIM_APPNAME="" nvim $@
  else
    NVIM_APPNAME=$(basename $config_dir)/$config nvim $@
  fi
  nvim $@
}
