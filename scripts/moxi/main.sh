#!/bin/bash

[ -z $SHELL_SETTINGS_DIR ] && source $HOME/github/shell-settings/scripts/.INIT

MOXI_BIN_DIR="${SCRIPTS_DIR}/moxi/bin"
PATH="${MOXI_BIN_DIR}:$PATH"

# override .SCRIPT_NAME from init so we log the correct name
.SCRIPT_NAME() {
  echo "moxi"
}

.main() {
  if [ $# -eq 0 ]; then
    .help
  fi

  local cmd="${1}"

  if [ "${cmd}" = "n" ]; then
    shift
    .notify "${@}"
  elif [ "${cmd}" = "h" ]; then
    .help
  elif [ "${cmd}" = "help" ]; then
    .help
  elif [ "${cmd}" = "--help" ]; then
    .help
  elif [ "${cmd}" = "--setup-ssh-agent" ]; then
    .setup_ssh_agent "$@"
  else
    die "Command not supported: \"${@}\""
  fi

  return 0
}

.help() {
  log "moxi --setup-ssh-agent"
  exit 0
}

.setup_ssh_agent() {
  log "Do stuff to make sure ssh-agent is working..."

  exit $?
}

.notify() {
  local default_timeout=5

  if isosx; then
    alerter \
      -title "\[moxi] notify" \
      -ignoreDnD \
      -timeout ${default_timeout} \
      -message "${@}" >/dev/null 2>&1 &

    # could have an option to use -sound if we don't want to speak the message
    /usr/bin/say "${@}"
  else
    die "${OS} not supported"
  fi
}

.main "$@"
