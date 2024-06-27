#!/usr/bin/env bash

echo_title() { echo -e "\n\033[30;44m $1 \033[0m"; }
echo_error() { echo -e "\033[31m[ error ] $1\033[0m"; }
echo_warning() { echo -e "\033[33m[ warning ] $1\033[0m"; }
echo_info() { echo -e "\033[34m[ info ] $1\033[0m"; }
echo_debug() { echo -e "\033[32m[ debug ] $1\033[0m"; }

requirements() {
    for requirement; do
        command -v $requirement &>/dev/null || {
            echo_error "Missing requirement: $requirement"
            exit 1
        }
    done
}

repos() {
    echo_title "Repositories of $1"
    curl -s "https://api.github.com/users/$1/repos?per_page=100" | jq -r '.[].git_url'
}

main() {
    requirements curl jq
    repos mackeper
}

main
