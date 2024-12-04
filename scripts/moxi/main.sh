#!/bin/bash

[ -z $SHELL_SETTINGS_DIR ] && source $HOME/github/shell-settings/scripts/.INIT

# override .SCRIPT_NAME from init so we log the correct name
.SCRIPT_NAME() {
  echo "moxi"
}

.help() {
  log "moxi --setup-ssh-agent"
  exit 0
}

.main() {
  if [ $# -eq 0 ]; then
    .help
  fi

  set +u
  local cmd="$1"

  if [ "${cmd}" = "--setup-ssh-agent" ]; then
    log "Comming soon!"
    return 0
  fi

  die "Command not supported: \"${@}\""
}

.main "${@}"
