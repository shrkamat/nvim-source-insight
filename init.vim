call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'pbogut/fzf-mru.vim'
Plug 'mhinz/vim-startify'
call plug#end()

set noerrorbells

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap

set noswapfile
set nobackup

set incsearch
set termguicolors

set nu
set scrolloff=8
set signcolumn=yes

set cmdheight=2

set updatetime=50

colorscheme gruvbox
