" Marcus Östling basic vimrc

"
" UI
"
set number
set so=7
set ruler
set showmatch
set mat=2
set foldcolumn=1

"
" Text/tabs
"
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ai
set si

"
" Searching
"
set ignorecase
set smartcase
set hlsearch
set incsearch

"
" Sounds (off)
"
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"
" Colors
"
syntax enable
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

try
	colorscheme desert
catch
endtry

set background=dark

"
" Font
"
set encoding=utf8
set ffs=unix,dos,mac

"
" Status line
"
set laststatus=2
