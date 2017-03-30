# Use absolute links when symlinking

e.g. `ln -sf /home/owner/shell-settings/folder /home/owner/.vim/folder`

# ~/.zsh-homerc

`export ZSH=/home/owner/.oh-my-zsh`

# For git submodules (e.g. ctrlp)

`git submodule update --init`

## YouCompleteMe

### Ensure all additional software is installed
```bash
sudo apt-get install build-essential cmake python-dev python3-dev npm rustc
```

### Building YouCompleteMe
```bash
cd ~/.vundle/plugins/YouCompleteMe
./install.py --all
```
