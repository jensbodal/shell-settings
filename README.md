# Using Automated Scripts

1. Install ZSH using your OS package manager or build from source
2. Install oh-my-zsh using provided script
3. Run setup script
4. If npm not installed, install npm
5. Run post setup instal script
6. Install pre-commit (e.g. `pip install pre-commit` or via your OS package manager)

## Git Hooks

We use [pre-commit](https://pre-commit.com/) to manage Git hooks across environments. To install Git hooks, run:

```bash
pre-commit install --install-hooks --hook-type pre-commit --hook-type pre-push
```

If you use npm, the hooks are installed automatically on `npm install` via the `prepare` script in `package.json`.

# Use absolute links when symlinking

e.g. `ln -sf /home/owner/shell-settings/folder /home/owner/.vim/folder`

# ~/.zsh-homerc

`export ZSH=/home/owner/.oh-my-zsh`

# For git submodules (e.g. ctrlp)

`git submodule update --init`

## YouCompleteMe

### Ensure all additional software is installed
```bash
sudo apt-get install exuberant-ctags npm vim
```

### Building YouCompleteMe
```bash
cd ~/.vundle/plugins/YouCompleteMe
./install.py --all
```

# Extra packages to install

```
# https://github.com/direnv/direnv/blob/master/docs/development.md
direnv
jq
zsh
...
```
# Notes

```
:w !sudo tee %
```

