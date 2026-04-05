set nocompatible
set ignorecase
set smartcase
set incsearch
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamed
set path+=**
set laststatus=2
set showcmd
let mapleader=" "
syntax on
filetype plugin indent on

" Navigation
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Window navigation
nnoremap <C-Left> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Right> <C-w>l

" Window splits
nnoremap <leader>ws <C-w>s
nnoremap <leader>wv <C-w>v

" Search
nnoremap <leader>h :nohlsearch<CR>

" Visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

" Buffer management
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bo :bufdo bd<CR>
nnoremap <leader>bc :enew<CR>
nnoremap <tab> :bnext<CR>
nnoremap <S-tab> :bprevious<CR>

" File explorer
nnoremap <leader>ee :Explore<CR>
