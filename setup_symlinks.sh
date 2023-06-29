#!/bin/bash

THIS_FOLDER=$PWD
THIS_VIM_FOLDER=$THIS_FOLDER'/.vim'

createsymlink() {
  local s="$1"
  local d="$2"

  if [ ! -L "$d" ]; then
    echo "! linking \"$s\" to \"$d\""
    ln -sf "$s" "$d"
  else
    echo "symlink \"$d\" already exists"
  fi
}

createsymlink $THIS_FOLDER/.zshrc $HOME/.zshrc
createsymlink $THIS_FOLDER/.aliasrc-shell-settings $HOME/.aliasrc-shell-settings
createsymlink $THIS_FOLDER/.zsh_completions $HOME/.zsh_completions
createsymlink $THIS_FOLDER/.vimrc $HOME/.vimrc
createsymlink $THIS_FOLDER/.direnvrc $HOME/.direnvrc

createsymlink $THIS_VIM_FOLDER/after $HOME/.vim/after
createsymlink $THIS_VIM_FOLDER/autoload $HOME/.vim/autoload
createsymlink $THIS_VIM_FOLDER/bundle $HOME/.vim/bundle
createsymlink $THIS_VIM_FOLDER/colors $HOME/.vim/colors
createsymlink $THIS_VIM_FOLDER/ftplugin $HOME/.vim/ftplugin
createsymlink $THIS_VIM_FOLDER/plugin $HOME/.vim/plugin

