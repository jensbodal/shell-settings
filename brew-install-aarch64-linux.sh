#!/bin/bash
# Modified from https://github.com/Homebrew/install/blob/master/install.sh
# https://github.com/Homebrew/install/commit/bcb04b7fcaa6509e6d9d9afc8007c5184302a82d

# On Linux, this script installs to /home/linuxbrew/.linuxbrew only
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
export HOMEBREW_CACHE="${HOME}/.cache/Homebrew"
export HOMEBREW_BREW_DEFAULT_GIT_REMOTE="https://github.com/Homebrew/brew"
export HOMEBREW_CORE_DEFAULT_GIT_REMOTE="https://github.com/Homebrew/homebrew-core"

# no analytics during installation
export HOMEBREW_NO_ANALYTICS_THIS_RUN=1
export HOMEBREW_NO_ANALYTICS_MESSAGE_OUTPUT=1

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"
  do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

__main() {
  local STAT_PRINTF=("/usr/bin/stat" "--printf")
  local PERMISSION_FORMAT="%a"
  local CHOWN=("/bin/chown")
  local CHGRP=("/bin/chgrp")
  local GROUP="$(id -gn)"
  local TOUCH=("/bin/touch")
  local INSTALL=("/usr/bin/install" -d -o "${USER}" -g "${GROUP}" -m "0755")
  local USABLE_GIT=/usr/bin/git

  # For Homebrew on Linux
  local REQUIRED_RUBY_VERSION=2.6    # https://github.com/Homebrew/brew/pull/6556
  local REQUIRED_GLIBC_VERSION=2.13  # https://docs.brew.sh/Homebrew-on-Linux#requirements
  local REQUIRED_CURL_VERSION=7.41.0 # HOMEBREW_MINIMUM_CURL_VERSION in brew.sh in Homebrew/brew
  local REQUIRED_GIT_VERSION=2.7.0   # HOMEBREW_MINIMUM_GIT_VERSION in brew.sh in Homebrew/brew

  # Use remote URLs of Homebrew repositories from environment if set.
  local HOMEBREW_BREW_GIT_REMOTE="${HOMEBREW_BREW_GIT_REMOTE:-"${HOMEBREW_BREW_DEFAULT_GIT_REMOTE}"}"
  local HOMEBREW_CORE_GIT_REMOTE="${HOMEBREW_CORE_GIT_REMOTE:-"${HOMEBREW_CORE_DEFAULT_GIT_REMOTE}"}"
  # The URLs with and without the '.git' suffix are the same Git remote. Do not prompt.
  if [[ "${HOMEBREW_BREW_GIT_REMOTE}" == "${HOMEBREW_BREW_DEFAULT_GIT_REMOTE}.git" ]]
  then
    HOMEBREW_BREW_GIT_REMOTE="${HOMEBREW_BREW_DEFAULT_GIT_REMOTE}"
  fi

  if [[ "${HOMEBREW_CORE_GIT_REMOTE}" == "${HOMEBREW_CORE_DEFAULT_GIT_REMOTE}.git" ]]
  then
    HOMEBREW_CORE_GIT_REMOTE="${HOMEBREW_CORE_DEFAULT_GIT_REMOTE}"
  fi

  export HOMEBREW_{BREW,CORE}_GIT_REMOTE


  unset HAVE_SUDO_ACCESS # unset this from the environment

  shell_rcfile="${ZDOTDIR:-"${HOME}"}/.zshrc"

  echo "- Install Homebrew's dependencies if you have sudo access:"

  if [[ -x "$(command -v apt-get)" ]]
  then
    sudo apt-get install build-essential
  elif [[ -x "$(command -v dnf)" ]]
  then
    sudo dnf group install development-tools
  elif [[ -x "$(command -v yum)" ]]
  then
    sudo yum groupinstall 'Development Tools'
  elif [[ -x "$(command -v pacman)" ]]
  then
    sudo pacman -S base-devel
  elif [[ -x "$(command -v apk)" ]]
  then
    sudo apk add build-base
  fi

  (
  cd "${HOMEBREW_REPOSITORY}" >/dev/null || return

  # we do it in four steps to avoid merge errors when reinstalling
  execute "${USABLE_GIT}" "-c" "init.defaultBranch=master" "init" "--quiet"

  # "git remote add" will fail if the remote is defined in the global config
  execute "${USABLE_GIT}" "config" "remote.origin.url" "${HOMEBREW_BREW_GIT_REMOTE}"
  execute "${USABLE_GIT}" "config" "remote.origin.fetch" "+refs/heads/*:refs/remotes/origin/*"

  # ensure we don't munge line endings on checkout
  execute "${USABLE_GIT}" "config" "--bool" "core.autocrlf" "false"

  # make sure symlinks are saved as-is
  execute "${USABLE_GIT}" "config" "--bool" "core.symlinks" "true"

  if [[ -z "${NONINTERACTIVE-}" ]]
  then
    quiet_progress=("--quiet" "--progress")
  else
    quiet_progress=("--quiet")
  fi
  execute "${USABLE_GIT}" "fetch" "${quiet_progress[@]}" "--force" "origin"
  execute "${USABLE_GIT}" "fetch" "${quiet_progress[@]}" "--force" "--tags" "origin"

  execute "${USABLE_GIT}" "remote" "set-head" "origin" "--auto" >/dev/null

  LATEST_GIT_TAG="$("${USABLE_GIT}" tag --list --sort="-version:refname" | head -n1)"
  if [[ -z "${LATEST_GIT_TAG}" ]]
  then
    abort "Failed to query latest Homebrew/brew Git tag."
  fi
  execute "${USABLE_GIT}" "checkout" "--quiet" "--force" "-B" "stable" "${LATEST_GIT_TAG}"

  if [[ "${HOMEBREW_REPOSITORY}" != "${HOMEBREW_PREFIX}" ]]
  then
    if [[ "${HOMEBREW_REPOSITORY}" == "${HOMEBREW_PREFIX}/Homebrew" ]]
    then
      execute "ln" "-sf" "../Homebrew/bin/brew" "${HOMEBREW_PREFIX}/bin/brew"
    else
      abort "The Homebrew/brew repository should be placed in the Homebrew prefix directory."
    fi
  fi

  if [[ -n "${HOMEBREW_NO_INSTALL_FROM_API-}" && ! -d "${HOMEBREW_CORE}" ]]
  then
    # Always use single-quoted strings with `exp` expressions
    # shellcheck disable=SC2016
    (
      execute "${MKDIR[@]}" "${HOMEBREW_CORE}"
      cd "${HOMEBREW_CORE}" >/dev/null || return

      execute "${USABLE_GIT}" "-c" "init.defaultBranch=master" "init" "--quiet"
      execute "${USABLE_GIT}" "config" "remote.origin.url" "${HOMEBREW_CORE_GIT_REMOTE}"
      execute "${USABLE_GIT}" "config" "remote.origin.fetch" "+refs/heads/*:refs/remotes/origin/*"
      execute "${USABLE_GIT}" "config" "--bool" "core.autocrlf" "false"
      execute "${USABLE_GIT}" "config" "--bool" "core.symlinks" "true"
      execute "${USABLE_GIT}" "fetch" "--force" "${quiet_progress[@]}" \
        "origin" "refs/heads/master:refs/remotes/origin/master"
      execute "${USABLE_GIT}" "remote" "set-head" "origin" "--auto" >/dev/null
      execute "${USABLE_GIT}" "reset" "--hard" "origin/master"

      cd "${HOMEBREW_REPOSITORY}" >/dev/null || return
    ) || exit 1
  fi

  execute "${HOMEBREW_PREFIX}/bin/brew" "update" "--force" "--quiet"
  ) || exit 1


if [[ ":${PATH}:" != *":${HOMEBREW_PREFIX}/bin:"* ]]
then
  warn "${HOMEBREW_PREFIX}/bin is not in your PATH.
  Instructions on how to configure your shell for Homebrew
  can be found in the 'Next steps' section below."
fi
}

have_sudo_access() {
  if [[ ! -x "/usr/bin/sudo" ]]
  then
    return 1
  fi

  local -a SUDO=("/usr/bin/sudo")
  if [[ -n "${SUDO_ASKPASS-}" ]]
  then
    SUDO+=("-A")
  elif [[ -n "${NONINTERACTIVE-}" ]]
  then
    SUDO+=("-n")
  fi

  if [[ -z "${HAVE_SUDO_ACCESS-}" ]]
  then
    if [[ -n "${NONINTERACTIVE-}" ]]
    then
      "${SUDO[@]}" -l mkdir &>/dev/null
    else
      "${SUDO[@]}" -v && "${SUDO[@]}" -l mkdir &>/dev/null
    fi
    HAVE_SUDO_ACCESS="$?"
  fi

  if [[ -n "${HOMEBREW_ON_MACOS-}" ]] && [[ "${HAVE_SUDO_ACCESS}" -ne 0 ]]
  then
    abort "Need sudo access on macOS (e.g. the user ${USER} needs to be an Administrator)!"
  fi

  return "${HAVE_SUDO_ACCESS}"
}

execute() {
  if ! "$@"
  then
    abort "$(printf "Failed during: %s" "$(shell_join "$@")")"
  fi
}

execute_sudo() {
  local -a args=("$@")
  if [[ "${EUID:-${UID}}" != "0" ]] && have_sudo_access
  then
    if [[ -n "${SUDO_ASKPASS-}" ]]
    then
      args=("-A" "${args[@]}")
    fi
    ohai "/usr/bin/sudo" "${args[@]}"
    execute "/usr/bin/sudo" "${args[@]}"
  else
    ohai "${args[@]}"
    execute "${args[@]}"
  fi
}

__main "$@"
