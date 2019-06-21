#!/bin/zsh

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

ln -sf $THIS_FOLDER/.zshrc $HOME/.zshrc
ln -sf $THIS_FOLDER/.vimrc $HOME/.vimrc
ln -sf $THIS_FOLDER/.direnvrc $HOME/.direnvrc
ln -sf $THIS_VIM_FOLDER/after $HOME/.vim/after
ln -sf $THIS_VIM_FOLDER/autoload $HOME/.vim/autoload
ln -sf $THIS_VIM_FOLDER/bundle $HOME/.vim/bundle
ln -sf $THIS_VIM_FOLDER/colors $HOME/.vim/colors
ln -sf $THIS_VIM_FOLDER/ftplugin $HOME/.vim/ftplugin
ln -sf $THIS_VIM_FOLDER/plugin $HOME/.vim/plugin

mkdir -p "$HOME/local/bin"
mkdir -p "$HOME/local/npm"
mkdir -p "$HOME/local/n"

echo "export ZSH=\$HOME/.oh-my-zsh" >> ~/.zsh-homerc
echo "export N_PREFIX=\$HOME/local/n" >> ~/.zsh-homerc
echo "export PATH=\$HOME/local/bin:\$HOME/local/npm/bin:\$HOME/local/n/bin:\$PATH" >> ~/.zsh-homerc

touch $HOME/.aliasrc

source $HOME/.zshrc
