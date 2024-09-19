#!/bin/bash

THIS_FOLDER=$PWD
THIS_VIM_FOLDER=$THIS_FOLDER'/.vim'

# sets `-euo pipefail`
# Adds scripts dir to PATH
# Adds error handling
# Globals:
# $SCRIPTS_DIR
# $SHELL_SETTINGS_DIR
# $(.SCRIPT_DIR)
# $(.SCRIPT_NAME)
[ ! "$_INIT_COMPLETE" ] && source $HOME/github/shell-settings/scripts/.INIT && export _INIT_COMPLETE=1

createsymlink() {
  local s="$1"
  local d="$2"

  if [ ! -L "$d" ]; then
    log "! linking \"$s\" to \"$d\""
    ln -sf "$s" "$d"
  fi
}

log -d "Checking for symlink update..."
createsymlink $THIS_FOLDER/.zshrc $HOME/.zshrc
createsymlink $THIS_FOLDER/.aliasrc-shell-settings $HOME/.aliasrc-shell-settings
createsymlink $THIS_FOLDER/.zsh_completions $HOME/.zsh_completions
createsymlink $THIS_FOLDER/.vimrc $HOME/.vimrc
createsymlink $THIS_FOLDER/.direnvrc $HOME/.direnvrc

createsymlink $THIS_FOLDER/jens-disagrees.zsh-theme $HOME/.oh-my-zsh/themes/jens-disagrees.zsh-theme

for d in `find ${THIS_VIM_FOLDER} -type d`; do
  vimfolder=`basename ${d}`
  symlink="${HOME}/.vim/${vimfolder}"

  if [ ! -L "$symlink" ]; then
    createsymlink "${d}" "${symlink}"
  fi
done

for f in `find "${SHELL_SETTINGS_DIR}/configurations" -type f`; do
  MAP_HOME="${SHELL_SETTINGS_DIR}/configurations/*/HOME/*"

  if [[ $f == $MAP_HOME ]]; then
    prefix=${f#"${SHELL_SETTINGS_DIR}/configurations/"}
    _filepath=`echo ${prefix} | sed -E 's#.*/HOME/(.*)#\1#'`
    _filename=`basename $_filepath`
    _filedirectory="$HOME/`dirname $_filepath`"
    _symlink="${_filedirectory}/${_filename}"

    if [ ! -L "${_symlink}" ]; then
      log -e
      mkdir -p "${_filedirectory}"
      createsymlink "${f}" "${_symlink}"
    fi
  fi
done
