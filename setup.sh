DATE_SUFFIX=$(date +%Y-%m-%d)
BACKUP_FOLDER=$HOME'/.shell_settings_backup/'$DATE_SUFFIX
BACKUP_VIM_FOLDER=$BACKUP_FOLDER/.vim
THIS_FOLDER=$PWD
THIS_VIM_FOLDER=$THIS_FOLDER'/.vim'

mkdir -p $BACKUP_VIM_FOLDER

mv -f ~/.vimrc $BACKUP_FOLDER
mv -f ~/.zshrc $BACKUP_FOLDER
mv -f ~/.vim/after $BACKUP_VIM_FOLDER
mv -f ~/.vim/autoload $BACKUP_VIM_FOLDER
mv -f ~/.vim/bundle $BACKUP_VIM_FOLDER
mv -f ~/.vim/colors $BACKUP_VIM_FOLDER
mv -f ~/.vim/ftplugin $BACKUP_VIM_FOLDER
mv -f ~/.vim/plugin $BACKUP_VIM_FOLDER

ln -sf $THIS_FOLDER/.zshrc $HOME/.zshrc
ln -sf $THIS_FOLDER/.vimrc $HOME/.vimrc
ln -sf $THIS_VIM_FOLDER/after $HOME/.vim/after
ln -sf $THIS_VIM_FOLDER/autoload $HOME/.vim/autoload
ln -sf $THIS_VIM_FOLDER/bundle $HOME/.vim/bundle
ln -sf $THIS_VIM_FOLDER/colors $HOME/.vim/colors
ln -sf $THIS_VIM_FOLDER/ftplugin $HOME/.vim/ftplugin
ln -sf $THIS_VIM_FOLDER/plugin $HOME/.vim/plugin

git submodule update --init
npm config set prefix=$HOME/node
