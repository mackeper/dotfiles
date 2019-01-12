"Marcus Östling neo vimrc

"
" vim-plug section
"

call plug#begin()

" on-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'terryma/vim-multiple-cursors'

Plug 'chriskempson/base16-vim'

call plug#end()

"
" Nerdtree
"
map <C-t> :NERDTreeToggle<CR>
" Close nerdtree if it is the only window left
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"
" Multiple-cursors
" Usage: Press <C-n> to select, v to enter normal, then i to insert. (Or c to
" change.)
let g:multi_cursor_use_default_mapping=1

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

"
" Terminal
"
:tnoremap <Esc> <C-\><C-n>

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
set visualbell
set t_vb=
set tm=500

"
" Colors
"
" colorscheme base16-materia
let base16colorspace=256
syntax enable

"
" Font
"
set encoding=utf8
set ffs=unix,dos,mac

"
" Status line
"
set laststatus=2

