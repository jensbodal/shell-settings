git submodule update --init
(cd .vim/bundle/vimproc.vim; make)

if ! type direnv>/dev/null; then
  echo "Install direnv: https://github.com/direnv/direnv/blob/master/docs/development.md"
  echo "mkdir -p ~/github"
  echo "cd ~/github"
  echo "git clone https://github.com/direnv/direnv.git"
  echo "cd direnv"
  echo "make"
  echo "make install"
fi

if type npm>/dev/null; then
  npm config set prefix=$HOME/local/npm

  if type yarn>/dev/null; then
    yarn config set prefix ~/local/yarn
    yarn global add n
    yarn global add jwt-cli
  else
    echo "Install yarn: https://classic.yarnpkg.com/en/docs/install/#manual-install-via-tarball"
  fi
else
  echo "Install node: https://nodejs.org/en/download/"
  echo "  1. install node (tar vxf *.tar.xz)"
  echo "  2. symlink node and npm versions to ~/local/bin"
  echo "  3. install yarn (tar zvxf): https://classic.yarnpkg.com/en/docs/install/#manual-install-via-tarball"
  echo "  4. install n"
  echo "  5. use n to install node/npm"
  echo "  6. remove symlinks and manual download of node"
fi

