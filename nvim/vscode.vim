call plug#begin('$HOME/.vim/bundle/plugged')
  Plug 'https://github.com/tpope/vim-commentary'
call plug#end()

" Unmap unwanted vscode-neovim mappings
unmap gt
unmap gT

"Set custom leader from \ to "
let mapleader='"'

" <C-u> is needed to clear prev count
" find current selection in files
nnoremap <silent> ? :<C-u>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>

" Repeat last macro
nnoremap <silent> , @@

" I don't know what C-U is but it was in the source
" https://github.com/asvetliakov/vscode-neovim/blob/master/vim/vscode-tab-commands.vim
nnoremap <silent> tt :<C-U>call VSCodeCall('workbench.action.nextEditorInGroup')<CR>
nnoremap <silent> th :<C-U>call VSCodeCall('workbench.action.firstEditorInGroup')<CR>
nnoremap <silent> tl :<C-U>call VSCodeCall('workbench.action.lastEditorInGroup')<CR>
nnoremap <silent> tp :<C-U>call VSCodeCall('workbench.action.previousEditorInGroup')<CR>

" disable settings which are enabled by default with nvim that can cause slowness
set noshowcmd
set noruler
