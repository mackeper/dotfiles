#!/usr/bin/env bash

# List of packages for apt
apt_packages=(
  # Terminal tools
  "ddgr"     # DuckDuckGo from the terminal
  "lolcat"   # Rainbow text
  "neofetch" # System info

  # CTF / Security
  "exiftool" # Read and write meta information in files
  "hexyl"    # Hex viewer
  "nmap"     # Network scanner
  "steghide" # Hide data in files
  "openvpn"  # VPN
)

# List of packages for npm
npm_packages=(
  "wikit" # Terminal wikipedia
)

# List of packages for pip
pip_packages=()

# List of packages for go install
go_packages=(
  "github.com/boyter/scc/v3@latest" # Count lines of code
)

# List of packages for cargo install
cargo_packages=(
  # Terminal tools
  "du-dust"  # Disk usage
  "onefetch" # Neofetch for git repos
  "procs"    # Alternative to ps
)

custom_packages=()
