if type brew>/dev/null; then
  brew install coreutils go jq yarn git-delta bat node switchaudio-osx hyperfine glow gnu-sed fzf
else
  echo "#################################################################################################"
  echo "# Not macos, find replacements for:"
  echo "#"
  echo "# coreutils go jq yarn git-delta bat node switchaudio-osx hyperfine glow gnu-sed fzf"
  echo "#################################################################################################"

  if [ ! -d ~/.asdf ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    pushd ~/.asdf
    git fetch --tags
    latestAsdfTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    git checkout $latestAsdfTag

    popd
    export PATH=$PATH:$HOME/.asdf/bin

    asdf plugin add direnv
    asdf plugin add nodejs
    asdf plugin add python

    asdf install direnv latest
    asdf install nodejs latest
    asdf install python latest

    asdf global direnv latest
    asdf global nodejs latest
    asdf global python latest

    asdf direnv setup --shell zsh --version latest
  fi
fi

if type npm>/dev/null; then
  npm config set prefix=$HOME/local/npm

  if ! type yarn>/dev/null; then
    npm install -g yarn
  fi

  if type yarn>/dev/null; then
    yarn config set prefix $HOME/local/yarn
    yarn global add n
    yarn global add jwt-cli
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

