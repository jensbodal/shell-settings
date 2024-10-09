#!/bin/bash

set -euo pipefail

export ZSH=$HOME/.oh-my-zsh

sudo apt install exuberant-ctags zsh zsh-autosuggestions zsh-syntax-highlighting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

while true; do
    read -p "Install tailscale? (y/N) " yn
    case $yn in
        [Yy]* ) curl -fsSL https://tailscale.com/install.sh | sh; break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done

