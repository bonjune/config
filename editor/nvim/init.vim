" Vim Plug
call plug#begin(stdpath('config') . '/plugged')

" File Navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Background
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Language Support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Language Plugins
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'plasticboy/vim-markdown'

call plug#end()

"""""""""""
" General "
"""""""""""
set relativenumber
set number

set history=500

" Automatically read changes
set autoread

filetype plugin on
filetype indent on

" Indentation by spaces instead of tabs
set expandtab
set shiftwidth=4
set tabstop=4

set ruler

" Searching
set smartcase
set hlsearch
set incsearch


set showmatch


syntax enable

set encoding=utf8

"""""""""""
" Mapping "
"""""""""""

" Forward search and backward search
map <space> /
map <C-space> ?

map <C-n> :NERDTreeToggle<CR>


" Moving around windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"""""""""""
" Status  "
"""""""""""

set laststatus=2

