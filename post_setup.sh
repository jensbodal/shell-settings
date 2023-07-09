#!/bin/bash

os=`uname -s`

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

install_brew_if_needed() {
  if [ islinux -o ismac ]; then
    if ! command -v brew &> /dev/null; then
      echo "brew not found, installing..."
      sleep 1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Run these two commands in your terminal to add Homebrew to your PATH:
      # #(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> $HOME/.zsh-homerc
      echo "Run this command to make brew immediately available"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      # install build-essential if we need it
      echo "PATH=/home/linuxbrew/.linuxbrew/bin:\$PATH" >> ~/.zsh-homerc
      echo "export PATH" >> ~/.zsh-homerc
      source ~/.zsh-homerc
    fi
  else
    return 1
  fi
}

asdf-install() {
  asdf plugin add "$1"
  asdf install "$1" latest
  asdf global "$1" latest
}

install_brew_if_needed

if command -v brew &> /dev/null; then
  brew install gcc bat coreutils gnupg gnu-sed gnu-tar hyperfine switchaudio-osx cmatrix
elif command -v apt &> /dev/null; then
  sudo apt update && \
    sudo apt install -y bat hyperfine # tar gpg
else
  echo "#################################################################"
  echo "# Not macos/linux, find replacements for:"
  echo "#"
  echo "# bat coreutils sed gpg hyperfine tar"
  echo "#################################################################"
fi

if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  pushd ~/.asdf
  git fetch --tags
  latestAsdfTag=$(git describe --tags `git rev-list --tags --max-count=1`)
  git checkout $latestAsdfTag

  popd
  export PATH=$PATH:$HOME/.asdf/bin
  asdf update

  # the following do not work on mac so just using native package managers
  # asdf-install bat
  # asdf-install hyperfine

  asdf-install delta
  asdf-install direnv
  asdf-install fzf
  asdf-install glow
  asdf-install golang
  asdf-install jq
  asdf-install nodejs
  asdf-install pnpm
  asdf-install python
  asdf-install rust
  asdf-install yarn

  asdf direnv setup --shell zsh --version latest
fi

if type npm>/dev/null; then
  npm config set prefix=$HOME/local/npm

  if ! type yarn>/dev/null; then
    npm install -g yarn
  fi

  if type yarn>/dev/null; then
    yarn config set prefix $HOME/local/yarn
    yarn global add n
    yarn global add jwt-cli --ignore-engines
  else
    echo "Install yarn: https://classic.yarnpkg.com/en/docs/install/#manual-install-via-tarball"
    brew install yarn
    exit 1
  fi
else
  echo "Install node: https://nodejs.org/en/download/"
  echo "  1. install node to $HOME/node-temp (tar vxf *.tar.xz)"
  echo "  2. symlink node and npm versions to ~/local/bin"
  echo "     - cd node*/bin"
  echo "     - ln -s \$(readlink -f node) \$HOME/local/bin/node"
  echo "     - ln -s \$(readlink -f ../lib/node_modules/npm/bin/npm-cli.js) \$HOME/local/bin/npm"
  echo "  3. install yarn (tar zvxf): https://classic.yarnpkg.com/en/docs/install/#manual-install-via-tarball"
  echo "     - brew install yarn"
  echo "     or"
  echo "     - ln -s $(readlink -f yarn) $HOME/local/bin/yarn"
  echo "  4. re-run this script"
  echo "      - install n"
  echo "      - use n to install node/npm"
  echo "      - remove symlinks and manual download of node"
  exit 1
fi

echo "Run this command to make brew immediately available"
echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""

