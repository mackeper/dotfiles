"Marcus Östling neo vimrc

"" vim-plug section

call plug#begin()
    " Directory tree, navigate directories
    Plug 'scrooloose/nerdtree'

    " Just one nerd tree
    Plug 'jistr/vim-nerdtree-tabs'

    " Nerdtree glyphs
    Plug 'ryanoasis/vim-devicons'

    " Color schemes
    " Plug 'chriskempson/base16-vim'

    " Easier commenting, 
    " [count]<leader>cc  comment lines
    " [count]<leader> cu  uncomment
    Plug 'scrooloose/nerdcommenter'

    " Lean & mean status bar
    Plug 'vim-airline/vim-airline'
    " Plug 'vim-airline/vim-airline-themes'

    " Ctrlp
    Plug 'ctrlpvim/ctrlp.vim'

    " Code completion
    " https://vimawesome.com/plugin/youcompleteme#quick-feature-summary
    " cd ~/.config/nvim/plugged/youcompleteme
    " python3 install.py --clang-completer
    " or
    " python3 install.py --all
    Plug 'valloric/youcompleteme'

    " Go between .h and .c
    Plug 'ericcurtin/CurtineIncSw.vim'

    " Colorscheme using pywal
    Plug 'dylanaraps/wal.vim'

    " Git wrapper :Gdiff, :Gread, :Gwrite, :Gcommit
    Plug 'tpope/vim-fugitive'

    " Show git edits in the left column
    Plug 'mhinz/vim-signify'
call plug#end()

"" Nerdtree
    " Close nerdtree if it is the only window left
    "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"" NERD COMMENTER
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

"" Airline
    let g:airline_powerline_fonts = 1
     
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif

    " unicode symbols
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'

    " airline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''

"" YouCompleteMe
    let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"

"" Mapping
    :let mapleader = "\<space>"

    " Navigate windows
    nmap <silent> <A-Up> :wincmd k<CR>
    nmap <silent> <A-Down> :wincmd j<CR>
    nmap <silent> <A-Left> :wincmd h<CR>
    nmap <silent> <A-Right> :wincmd l<CR>

    " Nerd tree
    "map <C-t> :NERDTreeToggle<CR>
    map <C-t> :NERDTreeTabsToggle<CR>

    " Terminal
    :tnoremap <Esc> <C-\><C-n>

    " MRU
    " noremap <C-m> :MRU<CR>
    " FZF
    " noremap <C-p> :FZF<CR>

    " CurtineIncSw
    map <leader>s :call CurtineIncSw()<CR>

"" UI
    "set number
    set so=7
    set ruler
    set showmatch
    set mat=2
    set foldcolumn=1

"" Text/tabs
    set expandtab
    set smarttab
    set shiftwidth=4
    set tabstop=4
    set ai
    set si

"" Searching
    set ignorecase
    set smartcase
    set hlsearch
    set incsearch

"" Sounds (off)
    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500

"" Colors
    " colorscheme base16-materia
    let base16colorspace=256
    set t_Co=256
    "let $NVIM_TUI_ENABLE_TRUE_COLOR=1 
    "set termguicolors " messes up
    colorscheme wal
    syntax enable

"" Mark column 81
    highlight OverLength ctermbg=blue ctermfg=white guibg=#592929
    match OverLength /\%81v./

"" Font
    set encoding=utf8
    set ffs=unix,dos,mac

"" Status line
    set laststatus=2

"" Filetype specific
    filetype indent plugin on
    autocmd FileType c setlocal shiftwidth=8 softtabstop=8 expandtab
    autocmd FileType cpp setlocal shiftwidth=4 softtabstop=4 expandtab
