"Marcus Östling neo vimrc

"
" vim-plug section
"

call plug#begin()

" Directory tree, navigate directories
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" multiple cursors, usage below
Plug 'terryma/vim-multiple-cursors'

" Color schemes
Plug 'chriskempson/base16-vim'

" Git wrapper, :Gstatus (- to add/reset), :Gcommit
Plug 'tpope/vim-fugitive'

" Easier commenting, 
" [count]<leader>cc  comment lines
" [count]<leader> cu  uncomment
Plug 'scrooloose/nerdcommenter'

" Lean & mean status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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
" NERD COMMENTER
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
 " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

"
" Mapping
"

:let mapleader = "\<space>"

"
" Airline
"
let g:airline_theme='papercolor'

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
set t_Co=256
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

