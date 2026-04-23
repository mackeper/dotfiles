#!/usr/bin/env bash

. /etc/os-release

packages="cmatrix cava fastfetch lolcat"


[[ "$ID" == "ubuntu" ]] && apt install -y $packages
[[ "$ID" == "fedora" ]] && dnf install -y $packages
[[ "$ID" == "arch" ]] && pacman -S --noconfirm $packages
