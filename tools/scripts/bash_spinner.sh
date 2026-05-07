#!/usr/bin/env bash
#
# Run a command with a spinner animation.
# 
# Spinners from:
#   https://github.com/sindresorhus/cli-spinners/blob/main/spinners.json
# Inspired by:
#   https://www.youtube.com/watch?v=muCcQ1W33tc (ysap.sh)
#
# Author: Marcus Östling <mpt.ostling@gmail.com>
# Date: 2026-04-25T22:23:09
# License: MIT

SPINNER_PID=
DEFAULT_THEME=dots
THEME=$DEFAULT_THEME
SPINNER_CHARS=

usage() {
    local program_name=${0##*/}
    cat <<-EOF
    Usage: $program_name [options] <command>

    Run a command with a spinner animation.

    Options:
      -h            Show this help message and exit
      -t <theme>    Choose a spinner theme (default: $DEFAULT_THEME)

    Themes:
      dots           ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏
      bar            | / - \\

    Example:
      $program_name sleep 5

EOF
}

spinner() {
    local c
    while true; do
        for c in ${SPINNER_CHARS[@]}; do
            printf ' %s \r' "$c"
            sleep 0.1
        done
    done
    printf "\n"
}

load_theme() {
    local theme=$1
    case $theme in
        dots) SPINNER_CHARS=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') ;;
        bar) SPINNER_CHARS=('|' '/' '-' '\') ;;
        *) echo "Unknown theme: $theme" >&2; usage >&2; exit 1 ;;
    esac
}

cleanup() {
    if [[ -n "$SPINNER_PID" ]]; then
        kill $SPINNER_PID
    fi
}

main() {
    local opts OPTIND OPTARG
    while getopts 'dht:' opts; do
        case $opts in
            h) usage; return 0 ;;
            t) THEME=$OPTARG ;;
            *) usage >&2; return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    if (( $# == 0)); then
        usage >&2
        return 1
    fi

    load_theme "$THEME"

    trap cleanup EXIT

    spinner &
    SPINNER_PID=$!

    "$@"

    echo "All tasks completed!"
}

main "$@"

