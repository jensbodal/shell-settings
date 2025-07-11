#!/bin/bash

# shellcheck disable=SC1091
[ -z "$SHELL_SETTINGS_INIT" ] && source "$HOME/github/shell-settings/scripts/_INIT"

MOXI_BIN_DIR="${SCRIPTS_DIR}/moxi/bin"
PATH="${MOXI_BIN_DIR}:$PATH"

# override .SCRIPT_NAME from init so we log the correct name
.SCRIPT_NAME() {
  echo "moxi"
}

.watch() {
  # shellcheck disable=SC2155
  local watchpath="$(realpath "${1}")"

  echo "Watching file \"${watchpath}\""
  nodemon -w "${watchpath}" -x "${watchpath}"
}

.main() {
  if [ $# -eq 0 ]; then
    .help
  fi

  local cmd="${1}"

  if [ "${cmd}" = "n" ]; then
    shift
    .notify "$@"
  elif [ "${cmd}" = "s" ]; then
    shift
    .notify "$@"
  elif [ "${cmd}" = "a" ]; then
    shift
    .announce "$@"
  elif [ "${cmd}" = "w" ]; then
    shift
    .watch "$@"
  elif [ "${cmd}" = "h" ]; then
    .help
  elif [ "${cmd}" = "help" ]; then
    .help
  elif [ "${cmd}" = "--help" ]; then
    .help
  elif [ "${cmd}" = "m" ]; then
    shift
    .monitor "$@"
  elif [ "${cmd}" = "monitor" ]; then
    shift
    .monitor "$@"
  elif [ "${cmd}" = "i" ]; then
    shift
    install "$@"
  elif [ "${cmd}" = "install" ]; then
    shift
    install "$@"
  elif [ "${cmd}" = "t" ]; then
    shift
    .throttle "$@"
  elif [ "${cmd}" = "throttle" ]; then
    shift
    .throttle "$@"
  elif [ "${cmd}" = "--setup-ssh-agent" ]; then
    .setup_ssh_agent "$@"
  else
    die "Command not supported: \"${*}\""
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

.announce() {
  local default_timeout=5

  if isosx; then
    alerter \
      -title "\[moxi] notify" \
      -ignoreDnD \
      -timeout ${default_timeout} \
      -message "Alexa announce that, ${*}" >/dev/null 2>&1 &

    # could have an option to use -sound if we don't want to speak the message
    /usr/bin/say -vAlex -r110 "Alexa announce ${*}"
  else
    die "${OS} not supported"
  fi
}

.notify() {
  local default_timeout=5

  if isosx; then
    alerter \
      -title "\[moxi] notify" \
      -ignoreDnD \
      -timeout ${default_timeout} \
      -message "${*}" >/dev/null 2>&1 &

    # could have an option to use -sound if we don't want to speak the message
    /usr/bin/say "${*}"
  else
    die "${OS} not supported"
  fi
}

# install helper - logic for handling installation of programs
i() {
  log "Installing [$*]"

  if [ "$1" = "shellcheck" ]; then
    brew install shellcheck
  elif [ "$1" = "shfmt" ]; then
    go install mvdan.cc/sh/v3/cmd/shfmt@latest 2>&1
  else
    die "No actual logic implemented. Add logic to $HOME/github/shell-settings/scripts/moxi/main.sh for: \"$*\""
  fi

}

install() {
  for a in "$@"; do
    i "$a"
  done

}

.main "$@"
# NOTHING BELOW THIS LINE
