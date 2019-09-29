git submodule update --init
(cd .vim/bundle/vimproc.vim; make)
npm config set prefix=$HOME/local/npm

yarn global add n
yarn global add jwt-cli
