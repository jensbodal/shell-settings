source $HOME/.config/nvim/keybindings.vim
source $HOME/.config/nvim/plugins.vim

"Set custom leader from \ to "
let mapleader='"'

"Sets shift ('<' and '>') column width
set shiftwidth=2

"Sets number of columns a tab equals (hitting tab in insert mode)
set softtabstop=2

"How many columns the \t stands for when reading files
set tabstop=4

"Adds a column marker at 80 characters wide
set colorcolumn=120

"Set default textwidth to unlimited, change default for file types elsewhere
set textwidth=120

"Highlight search
set hlsearch

"Adds line number marker
set number

"Allows switching to buffer without saving changes in current buffer
set hidden

"Converts tabs to spaces
set expandtab

"Keep same spacing on newline
set autoindent
set cindent

"Open files default without folding
" zM (fold-all) zR (unfold-all) zo (unfold current) zc (close) za (toggle)
set foldlevel=99

"Adds line number marker
set number

"Sets 'gutter' column indent to 3 spaces
set numberwidth=3

"Allow backspace in insert mode
set backspace=indent,eol,start

"Shows incomplete cmds at bottom right while in visual mode
set showcmd

"Color that is easier to see with dark background
"https://raw.githubusercontent.com/changyuheng/color-scheme-holokai-for-vim/master/colors/holokai.vim
colorscheme molokai

"Show line and column number as status text in bottom right
set ruler
" ????    "%s/#INSERT_FILE_NAME#/\=expand('%r')/

"bottomright right aligned with %=): col: # row: # (%) [filename]
set rulerformat=%50(%=col:\ %c\ row:\ %l\ \(%p%%\)\ [%f]%)

"Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

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

"Keep at least # lines above/below
set scrolloff=10

" Set colors for cursor line and column to a more readable format
hi! cursorcolumn cterm=NONE ctermbg=darkred ctermfg=white
hi! cursorline cterm=NONE ctermbg=darkred ctermfg=white

" :set list
set listchars=eol:$,tab:>.,trail:~,extends:>,precedes:<,nbsp:␣

