if type brew>/dev/null; then
  brew install coreutils go jq yarn git-delta bat node switchaudio-osx hyperfine glow gnu-sed
else
  echo "############################################################"
  echo "Not macos, find replacements for:"
  echo "  coreutils go jq yarn git-delta bat node switchaudio-osx hyperfine glow gnu-sed"
  echo "############################################################"
fi

if ! type direnv>/dev/null; then
  echo "Install direnv: https://github.com/direnv/direnv/blob/master/docs/development.md"
  echo "mkdir -p ~/github"
  echo "cd ~/github"
  echo "git clone https://github.com/direnv/direnv.git"
  echo "cd direnv"
  echo "go env -w GOPROXY=direct"
  echo "make"
  echo "make install PREFIX=~/local"
  mkdir -p ~/github && \
    cd ~/github && \
    git clone https://github.com/direnv/direnv.git && \
    cd direnv && \
    go env -w GOPROXY=direct && \
    make && \
    make install PREFIX=~/local && \
    pwd
  exit 1
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

