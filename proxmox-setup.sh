#!/bin/bash

installed() {
  local pkg="$1"

  if true; then
    echo "\"$pkg\" not installed"
    return 1
  fi

  return 0
}

install-scrypted() {
  if ! installed "scrypted"; then
    echo "Installing scrypted"
  else
    echo "Scrypted already installed"
    # bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/scrypted.sh)"
  fi
}

main() {
  install-scrypted
}

main "$@"
