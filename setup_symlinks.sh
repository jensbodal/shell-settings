#!/bin/bash

# sets `-euo pipefail`
# Adds scripts dir to PATH
# Adds error handling
# Globals:
# $SCRIPTS_DIR
# $SHELL_SETTINGS_DIR
# $(.SCRIPT_DIR)
# $(.SCRIPT_NAME)
[ ! "$_INIT_COMPLETE" ] && source $HOME/github/shell-settings/scripts/_INIT && export _INIT_COMPLETE=1

THIS_VIM_FOLDER="$SHELL_SETTINGS_DIR/.vim"

createsymlink() {
  local s="$1"
  local d="$2"

  if [ ! -L "$d" ]; then
    log "linking \"$s\" to \"$d\""
    ln -sf "$s" "$d"
  fi
}

log -d "Checking for symlink update..."
createsymlink ${SHELL_SETTINGS_DIR}/.zshrc $HOME/.zshrc
createsymlink ${SHELL_SETTINGS_DIR}/.aliasrc-shell-settings $HOME/.aliasrc-shell-settings
createsymlink ${SHELL_SETTINGS_DIR}/.zsh_completions $HOME/.zsh_completions
createsymlink ${SHELL_SETTINGS_DIR}/.vimrc $HOME/.vimrc
createsymlink ${SHELL_SETTINGS_DIR}/.direnvrc $HOME/.direnvrc

createsymlink ${SHELL_SETTINGS_DIR}/jens-disagrees.zsh-theme $HOME/.oh-my-zsh/themes/jens-disagrees.zsh-theme

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
