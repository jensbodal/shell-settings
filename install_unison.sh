# requires GNU make
# osx: brew install unison

function main() {
  # Currently broken because doesn't have below commit, hopefully 2.51.3 will fix?
  # wget https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz -O unison.v2.51.2.tar.gz
  curl https://github.com/ocaml/ocaml/archive/4.08.1.tar.gz -Lo ocaml.4.08.1.tar.gz
  git clone -n https://github.com/bcpierce00/unison.git

  tar zxvf ocaml.4.08.1.tar.gz

  pushd ocaml-4.08.1
  ./configure
  make world.opt
  sudo make install
  popd

  pushd unison
  git checkout 23fa129254a3304902739fc989950cc747d1e0b3
  make UISTYLE=text

  echo "Run the following commands to copy files to your PATH"
  echo "cp src/unison $HOME/local/bin"
  echo "cp src/unison-fsmonitor $HOME/local/bin"
}

mkdir -p $HOME/unison-installer
pushd $HOME/unison-installer
main
popd
