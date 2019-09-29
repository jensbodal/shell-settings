" *****************************************************************************
" These options are being used in Vim 7.4. If using an earlier version of VIM
" please note that some of them (such as colorcolumn and undofile) won't work
" *****************************************************************************
" MUST BE AT TOP FOR VUNDLE
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" init vundle and specify where to store plugins
call vundle#begin('~/local/vundle/plugins')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" Github Plugins

" -- MUST GO BEFORE vim-markdown --
Plugin 'godlygeek/tabular'
" ---------------------------------
Plugin 'plasticboy/vim-markdown'
Plugin 'leafgarland/typescript-vim'
Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}

" plugin from http://vim-scripts.org/vim/scripts.html
"   Plugin 'L9'

" Git plugin not hosted on GitHub
"   Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
"   Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"   Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"   Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Turns on highlighting of syntax
syntax on

"Set custom leader from \ to "
let mapleader='"'

"Sets shift ('<' and '>') column width
set shiftwidth=2

"Allows switching to buffer without saving changes in current buffer
set hidden
"Converts tabs to spaces
set expandtab

"Sets number of columns a tab equals (hitting tab in insert mode)
set softtabstop=2

"Keep same spacing on newline
set autoindent
set cindent

"How many columns the \t stands for when reading files
set tabstop=4

"Open files default without folding
" zM (fold-all) zR (unfold-all) zo (unfold current) zc (close) za (toggle)
set foldlevel=99

"Color that is easier to see with dark background
"https://raw.githubusercontent.com/changyuheng/color-scheme-holokai-for-vim/master/colors/holokai.vim
"colorscheme holokai
colorscheme molokai

"Adds a column marker at 80 characters wide
set colorcolumn=140

"Set default textwidth to unlimited, change default for file types elsewhere
set textwidth=140

"Set colorcolumn color
highlight colorcolumn ctermbg=red

"Highlight search
set hlsearch

"Adds line number marker
set number

"Sets 'gutter' column indent to 3 spaces
set numberwidth=3

"Allow backspace in insert mode
set backspace=indent,eol,start

"Shows incomplete cmds at bottom right while in visual mode
set showcmd

" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
" Set up swap, backup, and undo folders and enable persistent undo
if has('persistent_undo')
    let swapdir = expand("~/.vim/.swap")
    let bakdir = expand("~/.vim/.backup")
    let undodir = expand("~/.vim/.undo")

    if !isdirectory($HOME."/.vim")
        call mkdir($HOME."/.vim", "", 0770)
    endif

    if !isdirectory(swapdir)
        call mkdir(swapdir)
    endif

    if !isdirectory(bakdir)
        call mkdir(bakdir)
    endif

    if !isdirectory(undodir)
        call mkdir(undodir)
    endif
    "Set directory for all swap files to specific directory
    set directory=~/.vim/.swap//
    "Set directory for all backup files to specific directory
    set backupdir=~/.vim/.backup//
    "Sets permanent undo directory
    set undodir=~/.vim/.undo//
    "Turns on permanent undo history
    set undofile
endif
" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

"Enables auto completion
set wildmenu

"First <Tab> will complete longest common string and invoke wildmenu, next
"tab will complete the first alternative and then will start to cycle through
"set wildmode=longest:full,full
set wildmode=list:longest,full

"Show line and column number as status text in bottom right
set ruler
    "%s/#INSERT_FILE_NAME#/\=expand('%r')/

"bottomright right aligned with %=): col: # row: # (%) [filename]
set rulerformat=%50(%=col:\ %c\ row:\ %l\ \(%p%%\)\ [%f]%)

"New keybindings for moving around with different screens
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

" FUNCTIONS AND COMMANDS BELOW "

"Carriage return creates a newline, shift CR creates a new line after
nnoremap <CR> O<Esc>
nnoremap <S-CR> o<Esc>

"Use comma to repeat macro
nnoremap , @@

"Function to strip all trailing whitespace from files -- called automatically
"on save
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  retab
  call cursor(l, c)
endfun

autocmd FileType * autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

"HERE FOR REFERENCE INSERTING TEXT FROM FILE
"This function will insert a custom header text for a cpp file
"The contents of the file in ~/class/cs161/.header will be inserted at the top of the file you're in, and will
"automatically insert the filename and the date in the format: January 01, 1900
"A list of format options are found here: http://linux.die.net/man/3/strftime
" *****NOTE variable names are hardcored in the .header file for seach and replace*****
"function! InsertCPPHeader()
"    0r~/class/cs162/.header
"    %s/#INSERT_FILE_NAME#/\=expand('%r')/
"    %s/#INSERT_DATE#/\=strftime('%B %d, %Y')/
"    normal G
"endfunction

"Create command called Header to insert Header information at top of file
"command! Header execute InsertCPPHeader()

"Function to insert function headers for cpp files at current cursor location
"function! InsertCPPFunctionHeader()
"    normal O
"    r~/class/cs162/.function
"endfunction

"Command to call InsertCPPFunctionHeader()
"command! Function execute InsertCPPFunctionHeader()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Start pathogen manager on startup
execute pathogen#infect()

"Enables filetype plugin to allow extension spedific overrides
"e.g. ~/.vim/after/ftplugin/cpp.vim
"in cpp.vim: setlocal textwidth=80
filetype plugin on
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
"set omnifunc=syntaxcomplete#Complete

autocmd BufNewFile,BufRead * setlocal formatoptions-=r
"don't wrap text
autocmd BufNewFile,BufRead * setlocal formatoptions-=t
autocmd BufNewFile,BufRead .gitignore set filetype=zsh
autocmd BufNewFile,BufRead .aliasrc set filetype=zsh
autocmd BufNewFile,BufRead .envrc set filetype=zsh
autocmd BufNewFile,BufRead .direnvrc set filetype=zsh
autocmd BufNewFile,BufRead .eslintrc set filetype=javascript
autocmd BufNewFile,BufRead *.yaml,*.yml setf yaml
autocmd BufNewFile,BufRead Dockerfile,dockerfile setf Dockerfile
autocmd BufNewFile,BufRead Gruntfile.js setf Gruntfile.js
autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=8
autocmd Filetype gitcommit setlocal spell textwidth=80
autocmd FileType sql set filetype=mysql

"Remaps for working with tabs
nnoremap tt :tabnext<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>
nnoremap tp :tabp<CR>
nnoremap tn :tabnew<CR>


"Toggle line numbers
nnoremap <C-n> :set invnumber<CR>

"Min number of characters for completion YCM
let g:ycm_min_num_of_chars_for_completion=1

"Disable YCM by default
let g:ycm_auto_trigger=0

"turn off YCM
nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
"turn on YCM
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

fun! ToggleYCM()
  :let g:ycm_auto_trigger=1
endfun

map <leader>q :call ToggleYCM()<CR>

"Keep at least # lines above/below
set scrolloff=10
"hi! CursorColumn ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold
hi! cursorcolumn cterm=NONE ctermbg=darkred ctermfg=white
hi! cursorline cterm=NONE ctermbg=darkred ctermfg=white
nnoremap H :set cursorline! cursorcolumn!<CR>
nnoremap C :set cursorcolumn!<CR>

runtime macros/matchit.vim

"Another method for including a plugin...
set runtimepath^=~/.vim/bundle/ctrlp.vim

"Any of these folders will be ignored by ctrlp, notice the '\|' to escape the OR
let g:ctrlp_custom_ignore = 'node_modules\|bower_components'

"Place a .ctrlp in any folder to make that the 'root' folder for which ctrlp won't search above
let g:ctrlp_root_markers = ['.ctrlp']

set listchars=eol:$,tab:>.,trail:~,extends:>,precedes:<,nbsp:␣
