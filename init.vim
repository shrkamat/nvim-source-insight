call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'zackhsi/fzf-tags'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'pbogut/fzf-mru.vim'
Plug 'mhinz/vim-startify'
Plug 'vim-scripts/cscope.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'ojroques/nvim-lspfuzzy'

" dart
Plug 'dart-lang/dart-vim-plugin'
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

let mapleader = " "

" FZF customizations
nnoremap <silent> <F7> :Tags<CR>
nnoremap <silent> <F8> :BTags<CR>
nnoremap <silent> <leader>o :Files<CR>

" FZF cscope handling
function! Cscope(option, query)
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
  \ 'down': '40%'
  \ }
  function! opts.sink(lines)
    let data = split(a:lines)
    let file = split(data[0], ":")
    execute 'e ' . '+' . file[1] . ' ' . file[0]
  endfunction
  call fzf#run(opts)
endfunction

function! CscopeQuery(option)
  call inputsave()
  if a:option == '9'
    let query = input('Assignments to: ')
  elseif a:option == '3'
    let query = input('Functions calling: ')
  elseif a:option == '2'
    let query = input('Functions called by: ')
  elseif a:option == '6'
    let query = input('Egrep: ')
  elseif a:option == '7'
    let query = input('File: ')
  elseif a:option == '1'
    let query = input('Definition: ')
  elseif a:option == '8'
    let query = input('Files #including: ')
  elseif a:option == '0'
    let query = input('C Symbol: ')
  elseif a:option == '4'
    let query = input('Text: ')
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    call Cscope(a:option, query)
  else
    echom "Cancelled Search!"
  endif
endfunction

nnoremap <silent> <Leader>ca :call Cscope('9', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call Cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call Cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call Cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call Cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cs :call Cscope('0', expand('<cword>'))<CR>
" nnoremap <silent>  :call Cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call Cscope('4', expand('<cword>'))<CR>

nnoremap <silent> <Leader><Leader>ca :call CscopeQuery('0')<CR>
nnoremap <silent> <Leader><Leader>cc :call CscopeQuery('1')<CR>
nnoremap <silent> <Leader><Leader>cd :call CscopeQuery('2')<CR>
nnoremap <silent> <Leader><Leader>ce :call CscopeQuery('3')<CR>
nnoremap <silent> <Leader><Leader>cf :call CscopeQuery('4')<CR>
nnoremap <silent> <Leader><Leader>cg :call CscopeQuery('6')<CR>
nnoremap <silent> <Leader><Leader>ci :call CscopeQuery('7')<CR>
nnoremap <silent> <Leader><Leader>cs :call CscopeQuery('8')<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('9')<CR>


" startify customizations
let g:startify_change_to_dir=0


" nvim-compe customizations
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 3
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" lsp customizations

lua << EOF
require('lspfuzzy').setup {}
require'lspconfig'.clangd.setup {

    on_attach = function (client, buffnr)
        print ("clangd ....", buffnr );
        vim.api.nvim_buf_set_keymap(buffnr,'n', '=',        '<Cmd>lua vim.lsp.buf.definition()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<C-k>',    '<cmd>lua vim.lsp.buf.signature_help()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '',       '<cmd>lua vim.lsp.buf.references()<CR>',{noremap = true, silent = true});
    end
}

require'lspconfig'.gopls.setup {
    on_attach = function (client, buffnr)
        print ("gopls ....", buffnr );
        vim.api.nvim_buf_set_keymap(buffnr,'n', '=',        '<Cmd>lua vim.lsp.buf.definition()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<C-k>',    '<cmd>lua vim.lsp.buf.signature_help()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '',       '<cmd>lua vim.lsp.buf.references()<CR>',{noremap = true, silent = true});
    end
}

require'lspconfig'.dartls.setup {
    on_attach = function (client, buffnr)
        print ("dartls ....", buffnr );
        vim.api.nvim_buf_set_keymap(buffnr,'n', '=',        '<Cmd>lua vim.lsp.buf.definition()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<C-k>',    '<cmd>lua vim.lsp.buf.signature_help()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',{noremap = true, silent = true});
        vim.api.nvim_buf_set_keymap(buffnr,'n', '',       '<cmd>lua vim.lsp.buf.references()<CR>',{noremap = true, silent = true});
    end

    --  init_options = {
    --      closingLabels = fale,
    --      flutterOutline = true,
    --      onlyAnalyzeProjectsWithOpenFiles = false,
    --      outline = false,
    --      suggestFromUnimportedLibraries = true
    --  };
    --  root_dir = root_pattern("pubspec.yaml")
}
EOF
