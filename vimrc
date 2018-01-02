let g:airline_theme='cool'

" make Vim more useful
set nocompatible

" set the shell
set shell=bash

" enable filetype detection
filetype on

" enable filetype-specific plugins
filetype plugin on

" enable filetype-specific indenting
filetype indent on

" pasting text unmodified from other applications
set paste

" Try to detect file formats.
" Unix for new files and autodetect for the rest.
set fileformats=unix,dos,mac

" free cursor
set whichwrap=b,s,h,l,<,>,[,]

" make the status line always visible
set laststatus=2

" automatically re-read files when editted outsite of vim
" set autoread

" use the OS clipboard by default (on versions compiled with `+clipboard`)
if exists("+clipboard")
  set clipboard=unnamed
endif

" enhance command-line completion
if exists("+wildmenu")
  set wildmenu
endif

" type of wildmenu
set wildmode=longest:full,list:full

" allow cursor keys in insert mode
set esckeys

" allow backspace in insert mode
set backspace=indent,eol,start

" optimize for fast terminal connections
set ttyfast

" add the g flag to search/replace by default
set gdefault

" use UTF-8 without BOM
set termencoding=utf-8 nobomb
set encoding=utf-8 nobomb

" change mapleader
let mapleader=","

" don’t add empty newlines at the end of files
set binary
set noeol

" keep X lines of command-line history
set history=100

if v:version >= 500
  " try reducing the number of lines stored in a register
  set viminfo='500,f1,:100,/100
endif

" keep a backup-file
set backup
if exists("+writebackup")
  set writebackup
  set backupdir=~/.vim/backups
endif

" centralize backups, swapfiles and undo history
set directory=~/.vim/swaps
if exists("+undodir")
  set undodir=~/.vim/undo
endif

" look for embedded modelines at the top of the file
set modeline

" only look at this number of lines for modeline
set modelines=10

" enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" enable line numbers
set number

" don't automatically wrap on load
set nowrap

" don't automatically wrap text when typing
set fo-=t

" make tabs as wide as two spaces -> you can also use :retab
set tabstop=2

" number of spaces to use for each step of indent
set shiftwidth=2
set softtabstop=2

" expand tabs to spaces
set expandtab

" insert spaces for tabs according to shiftwidth
if exists("+smarttab")
  set smarttab
endif

if exists("+smartindent")
  set smartindent
endif

" show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" ignore case of searches
set ignorecase

" Use intelligent case while searching.
" If search string contains an upper case letter, disable ignorecase.
set smartcase

" incremental searching
if exists("+incsearch")
  set incsearch
endif

" toggle for "paste" & "nopaste"
set pastetoggle=<F2>

" enable mouse in all modes
"if exists("+mouse")
"  set mouse=a
"endif

" hide the mouse while typing
"set mousehide

" enable the popup menu
"set mousem=popup

" disable mouse mode
set mouse-=a

" split vertically to the right
set splitright

" split horizontally below
set splitbelow

" disable error bells
set noerrorbells

" don’t reset cursor to start of line when moving around
set nostartofline

" show the cursor position
if exists("+ruler")
  set ruler
endif

" Disable the splash screen (and some various tweaks for messages).
set shortmess=aTItoO

" status line definition
set statusline=[%n]\ %<%f%m%r\ %w\ %y\ \ <%{&fileformat}>\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%=[%b\ 0x%02B]\ [%o]\ %l,%c%V\/%L\ \ %P

" Show current mode in the status line.
set showmode

" Show the (partial) command as it’s being typed.
if exists("+showcmd")
  set showcmd
endif

" Show the filename in the window titlebar.
if exists("+title")
  set title
endif

" When closing a block, show the matching bracket.
set showmatch

" Include angle brackets in matching.
set matchpairs+=<:>

" Do not redraw the screen while macros are running.
set lazyredraw

" Save files before performing certain actions.
"set autowrite

" use relative line numbers
"if exists("+relativenumber")
" set relativenumber
" au BufReadPost * set relativenumber
"endif

" Start scrolling at this number of lines from the bottom.
"set scrolloff=2

" Start scrolling three lines before the horizontal window border.
"set scrolloff=3

" Start scrolling horizontally at this number of columns.
"set sidescrolloff=5

" IMPORTANT: Uncomment one of the following lines to force
" using 256 colors (or 88 colors) if your terminal supports it,
" but does not automatically use 256 colors by default.
"set t_Co=256

" switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  " set the color-theme
  "let g:solarized_termcolors=256
  try
    "colorscheme molokai
    "colorscheme solarized_dark
    colorscheme monokai
  catch /^Vim\%((\a\+)\)\=:E185/
    " not available
  endtry

  " Enable coloring for dark background terminals.
  if has('gui_running')
    set background=light
  else
    set background=dark
  endif

  " turn on color syntax highlighting
  if exists("+syntax")
    syntax on
  endif

  syn sync fromstart

  " set to 256 colors
  set t_Co=256

  " Also switch on highlighting the last used search pattern.
  if exists("+hlsearch")
    set hlsearch
  endif

  " highlight current line
  if exists("+cursorline")
    set cursorline
  endif
endif

" copy between different vim sessions
:nmap _Y :!echo “”> ~/.vim/tmp<CR><CR>:w! ~/.vim/tmp<CR>
:vmap _Y :w! ~/.vim/tmp<CR>
:nmap _P :r ~/.vim/tmp<CR>

" stop opening man pages
:nmap K <nop>

" strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" automatic commands
if has("autocmd")
  " enable file type detection
  filetype on
  " treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif

" https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
endif

" don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noundofile
    augroup END
endif

" don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                \ setlocal viminfo=
        augroup END
    endif
endif

