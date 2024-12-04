#!/bin/bash

[ -z $SHELL_SETTINGS_DIR ] && source $HOME/github/shell-settings/scripts/.INIT

# override .SCRIPT_NAME from init so we log the correct name
.SCRIPT_NAME() {
  echo "moxi"
}

.main() {
  if [ $# -eq 0 ]; then
    .help
  fi

  local cmd="${1}"

  if [ "${cmd}" = "--help" ]; then
    .help
  fi

  if [ "${cmd}" = "--setup-ssh-agent" ]; then
    .setup_ssh_agent "$@"
  fi

  die "Command not supported: \"${@}\""
}

.help() {
  log "moxi --setup-ssh-agent"
  exit 0
}

.setup_ssh_agent() {
  log "Do stuff to make sure ssh-agent is working..."

  exit $?
}

.main "$@"
