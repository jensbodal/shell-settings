#!/bin/bash

os=`uname -s`
arch=`uname -m`

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

isarm() {
  if [ "$arch" == "arm64" -o "$arch" == "aarch64" ]; then
    return 0
  fi
  return 1
}

islinux64() {
  if [ "$arch" == "x86_64" ]; then
    if [ $os = "Linux" -a exists apt ]; then
      # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
      sudo apt install build-essential libssl-dev zlib1g-dev build-essential \
        libbz2-dev libreadline-dev libsqlite3-dev curl \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
      return 0
    fi
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

havebrew() {
  if ! command -v brew &> /dev/null; then
    return 1
  fi
  return 0
}

install_brew_from_source() {

  if command -v apt-get &> /dev/null; then
    sudo apt-get install -y build-essential procps curl file git
  elif command -v yum &> /dev/null; then
    packageList="procps-ng curl file git perl-IPC-Cmd"

    sudo yum groupinstall -y 'Development Tools'

    for packageName in $packageList; do
      rpm --quiet --query $packageName || sudo yum install -y $packageName
    done

  elif command -v pacman &> /dev/null; then
    sudo pacman -S base-devel procps-ng curl file git
  fi

  if ! command -v ruby &> /dev/null; then
    echo "You need to install ruby :-)"
    return 1
  fi

  if [ ! -d $HOME/github ]; then
    mkdir -p $HOME/github
  fi

  if [ ! -d $HOME/github/brew ]; then
    git clone https://github.com/Homebrew/brew.git $HOME/github/brew

    cd $HOME/github/brew

    # Get new tags from remote
    git fetch --tags

    # Get latest tag name
    latestTag=$(git describe --tags "$(git rev-list --tags --max-count=1)")

    # Checkout latest tag
    git checkout $latestTag -b "latest-tag-$latestTag"
  fi

  export PATH="$PATH:$HOME/github/brew/bin"
  mise install ruby@3.3
}

install_brew_if_needed() {
  if havebrew; then
    return 0
  fi

  echo "brew not found, installing..."

  if islinux64 || ismac; then
      sleep 1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Run these two commands in your terminal to add Homebrew to your PATH:
      # #(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.zsh-homerc
      echo "Run this command to make brew immediately available"

    if islinux64; then
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
    return 0
  fi

  if isarm; then
    install_brew_from_source
    return $?
  fi

  return 1

}

install_brew_if_needed

if havebrew; then
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

if install_mise; then
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
