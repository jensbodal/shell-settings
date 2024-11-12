#!/bin/zsh

if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  echo "Install zsh and oh-my-zsh first"
  echo "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
  exit 1
fi

DATE_SUFFIX=$(date +%Y-%m-%d-%s)
BACKUP_FOLDER=$HOME'/.shell_settings_backup/'$DATE_SUFFIX
BACKUP_VIM_FOLDER=$BACKUP_FOLDER/.vim
THIS_FOLDER=$PWD
THIS_VIM_FOLDER=$THIS_FOLDER'/.vim'

mkdir -p $BACKUP_VIM_FOLDER

mv -f ~/.vimrc $BACKUP_FOLDER 2>/dev/null
mv -f ~/.zshrc $BACKUP_FOLDER 2>/dev/null
mv -f ~/.vim/after $BACKUP_VIM_FOLDER 2>/dev/null
mv -f ~/.vim/autoload $BACKUP_VIM_FOLDER 2>/dev/null
mv -f ~/.vim/bundle $BACKUP_VIM_FOLDER 2>/dev/null
mv -f ~/.vim/colors $BACKUP_VIM_FOLDER 2>/dev/null
mv -f ~/.vim/ftplugin $BACKUP_VIM_FOLDER 2>/dev/null
mv -f ~/.vim/plugin $BACKUP_VIM_FOLDER 2>/dev/null

mkdir -p ~/.vim

./setup_symlinks.sh

mkdir -p "$HOME/local/bin"
mkdir -p "$HOME/local/npm"
mkdir -p "$HOME/local/n"

echo "export USER=\$(id -un)" >> ~/.zsh-homerc
echo "export ZSH=\$HOME/.oh-my-zsh" >> ~/.zsh-homerc
echo "export N_PREFIX=\$HOME/local/n" >> ~/.zsh-homerc
echo "" >> ~/.zsh-homerc
echo "PATH=\$HOME/local/npm/bin:\$PATH" >> ~/.zsh-homerc
echo "PATH=\$HOME/local/n/bin:\$PATH" >> ~/.zsh-homerc
echo "PATH=\$HOME/local/bin:\$PATH" >> ~/.zsh-homerc

echo "export PATH" >> ~/.zsh-homerc

touch $HOME/.aliasrc

source $HOME/.zshrc
