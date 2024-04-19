#!/usr/bin/env bash

function create_dotfiles_session() {
  session_name="dotfiles"
  tmux new-session -d -n "Editor" -c ~/git/dotfiles -s $session_name
  tmux send-keys -t "dotfiles:Editor" "nvim" Enter

  tmux new-window -t "$session_name:" -n 'dotfiles' -c ~/git/dotfiles

  tmux new-window -t "$session_name:" -n 'SeshMgr' -c ~/git/SeshMgr.nvim
  # tmux send-keys -t "$session_name:SeshMgr" "nvim" Enter
  tmux select-window -t "$session_name:Editor"
}

function create_kattis_session() {
  session_name="kattis"
  tmux new-session -d -n "Editor" -c ~/git/AlgorithmsAndDataStructures/kattis -s $session_name
  tmux send-keys -t "$session_name:Editor" "nvim" Enter

  tmux new-window -t "$session_name:" -n 'Kattis' -c ~/git/AlgorithmsAndDataStructures/kattis
  tmux new-window -t "$session_name:" -n 'Algorithms' -c ~/git/AlgorithmsAndDataStructures/algorithms/csharp
  tmux new-window -t "$session_name:" -n 'DataStructures' -c ~/git/AlgorithmsAndDataStructures/datastructures/csharp

  tmux select-window -t "$session_name:Editor"
}

if [ $# -ne 1 ]; then
  echo "Usage: $0 <session_name>"
  exit 1
fi

if tmux has-session -t "$1" 2>/dev/null; then
  echo "Session '$1' already exists."
  # if in tmux
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach -t "$1"
  fi
  exit 0
fi

case $1 in
"dotfiles")
  create_dotfiles_session
  ;;
"kattis")
  create_kattis_session
  ;;
*)
  echo "Invalid session name"
  exit 1
  ;;
esac
