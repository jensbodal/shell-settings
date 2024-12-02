" ****************************************************************************************************
" Overview of which map command works in which mode.  More details below.
" ------------------------------------------------------------------------
"      COMMANDS                    MODES ~
" :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
" :nmap  :nnoremap :nunmap    Normal
" :vmap  :vnoremap :vunmap    Visual and Select
" :smap  :snoremap :sunmap    Select
" :xmap  :xnoremap :xunmap    Visual
" :omap  :onoremap :ounmap    Operator-pending
" :map!  :noremap! :unmap!    Insert and Command-line
" :imap  :inoremap :iunmap    Insert
" :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
" :cmap  :cnoremap :cunmap    Command-line
" ------------------------------------------------------------------------
" :map j gg
" :map Q j
" :noremap W j
" j will be mapped to gg.
" Q will also be mapped to gg, because j will be expanded for the recursive mapping.
" W will be mapped to j (and not to gg) because j will not be expanded for the non-recursive mapping.
" ****************************************************************************************************
"
if exists('g:vscode')
  " VSCode extension
  source $HOME/.config/nvim/vscode.vim
else
  " Ordinary neovim
  source $HOME/.config/nvim/default.vim
endif
