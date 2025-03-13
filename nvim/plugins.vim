"Another method for including a plugin...
set runtimepath^=~/.vim/bundle/ctrlp.vim

if !isdirectory($HOME."/.vim")
  call mkdir($HOME."/.vim/bunle/plugged", "", 0770)
endif

" vim-plug plugins https://github.com/junegunn/vim-plug
" Install with PlugInstall
" Update with PlugUpdate
" https://github.com/junegunn/vim-plug#commands
" Autoloaded from ~/.vim/autoload
call plug#begin('$HOME/.vim/bundle/plugged')
  Plug 'https://github.com/tpope/vim-commentary'
call plug#end()

autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType typescript setlocal commentstring=//\ %s

"Any of these folders will be ignored by ctrlp, notice the '\|' to escape the OR
let g:ctrlp_custom_ignore = 'node_modules\|bower_components'

"Place a .ctrlp in any folder to make that the 'root' folder for which ctrlp won't search above
let g:ctrlp_root_markers = ['.ctrlp']

