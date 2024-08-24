#!/bin/bash

os=`uname -s`

exists() {
  if [ $# -ne 1 ]; then
    echo "You can only check a single command at a time"
    exit 1;
  fi

  command -v "$1" &> /dev/null
  return $?
}

i() {
  if [ $# -eq 0 ]; then
    return 0
  fi

  local os=`uname -s`
  local mgr=
  local pkgs="$@"

  if exists brew; then
    mgr="brew install";
  fi

  if [ $os != "Darwin" ]; then
    if exists pacman; then
      mgr="sudo pacman -S";
    elif exists apt; then
      mgr="sudo apt install";
    elif exists yum; then
      mgr="sudo yum install";
    fi
  fi

  eval $(echo "$mgr $pkgs")

  if [ $? -ne 0 -a $os != "Darwin" ]; then
    if exists brew; then
      brew install "$pkgs"
    fi
  fi
}

islinux() {
  if [ $os = "Linux" ]; then
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    sudo apt install build-essential libssl-dev zlib1g-dev build-essential \
      libbz2-dev libreadline-dev libsqlite3-dev curl \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    return 0
  fi
  return 1
}

ismac() {
  if [ $os = "Darwin" ]; then
    return 0
  fi
  return 1
}

mise-install() {
  if exists "$1" ; then
    echo "$1 exists, not doing anything..."
    return 0
  fi
  mise plugin add "$1"
  mise install "$1@latest"
  mise global "$1@latest"
}

install_brew_if_needed() {
  if [ islinux -o ismac ]; then
    if ! command -v brew &> /dev/null; then
      echo "brew not found, installing..."
      sleep 1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Run these two commands in your terminal to add Homebrew to your PATH:
      # #(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.zsh-homerc
      echo "Run this command to make brew immediately available"
    fi

    if islinux; then
      echo "PATH=/home/linuxbrew/.linuxbrew/bin:\$PATH" >> ~/.zsh-homerc
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif ismac; then
      echo "PATH=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:\$PATH" >> ~/.zsh-homerc
      echo "PATH=$HOMEBREW_PREFIX/opt/homebrew/opt/gnu-sed/libexec/gnubin:\$PATH" >> ~/.zsh-homerc
      echo "PATH=$HOMEBREW_PREFIX/opt/make/libexec/gnubin:\$PATH" >> ~/.zsh-homerc
      eval "$(/opt/homebrew/bin/brew shellenv)"
      /opt/homebrew/bin/brew autoupdate start
    fi

    echo "export PATH" >> ~/.zsh-homerc
    source ~/.zsh-homerc
  else
    return 1
  fi

  return 0
}

install_brew_if_needed

if command -v brew &> /dev/null; then
  brew tap mike-engel/jwt-cli
  brew install fx fzf gcc bat cmatrix coreutils gnupg gnu-sed gnu-tar jwt-cli
  if ismac; then
    brew install hyperfine switchaudio-osx make
  fi
elif command -v apt &> /dev/null; then
  sudo apt update && \
    sudo apt install -y bat hyperfine make
elif command -v pacman &> /dev/null; then
  pacman --noconfirm -Syu && \
    pacman --noconfirm -S bat hyperfine make
else
  echo "#################################################################"
  echo "# Not macos/linux or package manager not supported"
  echo "#################################################################"
  exit 1337
fi

if ! command -v wget &> /dev/null; then
  echo "[post_setup] Error! Missing \"wget\". Attempting to install with package manager"
  i wget

  if [ $? -ne 0 ]; then
    echo "Failed to install wget"
    exit 187
  fi
fi

if ! command -v mise &> /dev/null; then
  brew install mise
  export PATH=$PATH:$HOMEBREW_PREFIX/bin

  # the following do not work on mac so just using native package managers
  # mise-install bat
  # mise-install hyperfine

  mise-install delta
  mise-install direnv
  # does not like to work with zsh
  #mise-install fzf
  #mise-install glow
  mise-install golang
  mise-install jq
  mise-install nodejs
  mise-install pnpm
  mise-install python
  mise-install rust

  #mise direnv setup --shell zsh --version latest
fi

if exists npm; then
  npm config set prefix=$HOME/local/npm
else
  echo "Missing npm; set it up then run:"
  echo "npm config set prefix=\$HOME/local/npm"
fi
