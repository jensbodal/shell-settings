" ******************
" Normal mode remaps
" ******************
"
" Repeat last macro
nnoremap <silent> , @@

" Remaps for working with tabs
nnoremap <silent> tt :tabnext<CR>
nnoremap <silent> th :tabfirst<CR>
nnoremap <silent> tl :tablast<CR>
nnoremap <silent> tp :tabp<CR>
nnoremap <silent> tn :tabnew<CR>

" New keybindings for moving around with different screens
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Toggle line numbers
nnoremap <C-n> :set invnumber<CR>

" Create a color line or column using H or C
nnoremap H :set cursorline! cursorcolumn!<CR>
nnoremap C :set cursorcolumn!<CR>

