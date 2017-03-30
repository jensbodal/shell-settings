# Using Automated Scripts

1. Install ZSH using your OS package manager or build from source
2. Install oh-my-zsh using provided script
3. Run setup script
4. If npm not installed, install npm
5. Run post setup instal script

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
