call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'yuki-yano/fzf-preview.vim'
Plug 'sharkdp/bat'
" Plug 'zackhsi/fzf-tags'
Plug 'sainnhe/gruvbox-material'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-obsession'
" Plug 'pbogut/fzf-mru.vim'
Plug 'mhinz/vim-startify'
Plug 'vim-scripts/cscope.vim'
Plug 'jiangmiao/auto-pairs'

" syntax highlighting
Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'


" dart / flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" rust
" Plug 'rust-lang/rust.vim'


" snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'Neevash/awesome-flutter-snippets'

" meson
Plug 'stfl/meson.vim'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" debug
Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'

" Github MD previewer
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'

" utils
" Highlight in different colors
" Plug 'joanrivera/vim-highlight'
Plug 'shrkamat/vim-highlight'           " fork - new command HighlightCustom
Plug 'shrkamat/vim-log-syntax'          " fork - for log analysis
" Plug 'RRethy/vim-illuminate'
Plug 'machakann/vim-highlightedyank'
Plug 'gennaro-tedesco/nvim-peekup'

" Code commenting
Plug 'preservim/nerdcommenter'

call plug#end()

set noerrorbells

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set clipboard^=unnamed,unnamedplus

set noswapfile
set nobackup

set incsearch
set termguicolors

set nu
set scrolloff=8
set signcolumn=yes

set cmdheight=2

set updatetime=50

syntax enable
filetype plugin indent on

colorscheme gruvbox-material
set background=dark
" set cursorline          " set this after colorscheme

let mapleader = " "

" FZF customizations
nnoremap <silent> <F7> :Tags<CR>
nnoremap <silent> <F8> :BTags<CR>
nnoremap <silent> <leader>o :Files<CR>

" ls commad lists buffers, <leader> ls lists buffers in FZF
nnoremap <silent> <leader>ls :Buffers<CR>

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

" vim-illuminate customizations
let g:Illuminate_delay = 1000

" nvim-compe customizations
set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 2
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

" telescope customizations
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap * *N
nnoremap <leader>gg *N <cmd>Telescope grep_string<CR>
nnoremap <f9> <cmd>Telescope live_grep<cr>

" rust customizations
let g:rustfmt_autosave = 1

" SK: For easy navigation
" '+' takes you to definition
" '-' brings you back
nnoremap <silent> = :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> - <C-o>


" lsp customizations

lua << EOF

local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  -- args = {os.getenv('HOME') .. '/apps/vscode-node-debug2/out/src/nodeDebug.js'},
  args = {'/home/skamath/proactive/js/vscode-node-debug2/out/src/nodeDebug.js'},
}

require('lspfuzzy').setup {}

local on_attach_common = function(client, buffnr)
    local opts = { noremap=true, silent=true };
    vim.api.nvim_buf_set_keymap(buffnr,'n', '=',            '<Cmd>lua vim.lsp.buf.definition()<CR>', opts);
    vim.api.nvim_buf_set_keymap(buffnr,'n', '?',            '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts);
    vim.api.nvim_buf_set_keymap(buffnr,'n', '<F1>',         '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts);
    vim.api.nvim_buf_set_keymap(buffnr,'n', 'K',            '<cmd>lua vim.lsp.buf.hover()<CR>', opts);
    vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>wl',    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>rn',    '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>ca',    '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(buffnr,'n', '<space>e',     '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts);
    vim.api.nvim_buf_set_keymap(buffnr,'n', '',           '*N <cmd>lua vim.lsp.buf.references()<CR>', opts);
end

local lsp_status = require('lsp-status')
lsp_status.register_progress()

  lsp_status.config({
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'i',
    indicator_hint = '?',
    indicator_ok = 'Ok',
  });

require'lspconfig'.clangd.setup {
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    capabilities = lsp_status.capabilities,
    on_attach = function (client, buffnr)
        print ("clangd ....", buffnr);
        lsp_status.extensions.clangd.setup();
        lsp_status.on_attach(client);
        on_attach_common(client, buffnr);
    end,
    --- use when debugging lsp
    --- cmd = {"/ws/skamath/proactive/toolchain/tc-build/build/llvm/stage1/bin/clangd",  "--log=verbose", "--background-index"},
    --- without root_dir compile_commands.json was not being picked up
    root_dir = require'lspconfig'.util.root_pattern("compile_commands.json") or dirname
}

require'lspconfig'.gopls.setup {
    on_attach = function (client, buffnr)
        print ("gopls ....", buffnr );
        on_attach_common(client, buffnr);
    end
}

require'lspconfig'.dartls.setup {
    on_attach = function (client, buffnr)
        print ("dartls ....", buffnr );
        on_attach_common(client, buffnr);
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

require'lspconfig'.tsserver.setup {
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    capabilities = lsp_status.capabilities,
    on_attach = function (client, buffnr)
        print ("ts/js ....", buffnr);
        lsp_status.on_attach(client);
        on_attach_common(client, buffnr);
    end
}

require'lspconfig'.rust_analyzer.setup {
    on_attach = function (client, buffnr)
        print ("rust-analyzer .. ..", buffnr);
        on_attach_common(client, buffnr);
    end
}

-- TODO
-- require "nvim-treesitter.configs".setup {
--    playground = {
--        enable = true,
--        disable = {}
--    }
-- }

require('telescope').setup {
    defaults = {
        layout_config = {
            prompt_position = 'top'
        },
        sorting_strategy = 'ascending'
    }
}

EOF

" LspStatus
function! LspStatusLine() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%{LspStatusLine()}

" i changes mode to TERMINAL mode
" on esc exit terminal mode & buffer delete
augroup run
    autocmd!
    autocmd filetype cpp  nnoremap <f5> :w <bar> !g++ -g -O0 % <cr> :vnew <bar> :te ./a.out < inp.txt <cr> i
    autocmd filetype dart nnoremap <f5> :w <bar> :vnew <bar> :te dart run <cr> i
    autocmd filetype rust  nnoremap <f5> :! cargo run<cr>
    autocmd filetype javascript  nnoremap <f5> :! node run<cr>

    autocmd filetype qml nnoremap <f5> :w <bar> :! /home/skamath/Qt5.4.2/5.4/gcc_64/bin/qmlscene % <CR>

    " SK: don't rely on this for autocmd
    autocmd filetype vim  nnoremap <f5> :w <bar> :so % <cr>
augroup END

" exit terminal mode with ESC
:tnoremap <Esc> <C-\><C-n><CR> :bd!<CR>


" SKM Group this later
nnoremap <C-A> ggVG
nnoremap <silent> <leader>g :Telescope grep_string <CR>
vnoremap <silent> <leader>g :Telescope grep_string <CR>

" FOLDS: https://www.youtube.com/watch?v=oqYQ7IeDs0E
" Add experimental stuffs here and then formalize
set foldmethod=syntax
set foldlevel=99
" zM => folds to max
" zm => increase fold level by one
" zr => decrease fold level by one
" zR => unfolds to max (same as original document)
" zo => opens fold under cursor
" zc => closes a fold under cursor
" TODO: how to recursively open up a fold and close a fold

" Tab to switch VimTabs
nnoremap <silent> <Tab> gt
nnoremap <silent> <S-Tab> gT

" save on CTRL-S
noremap  <silent> <C-S>          :update<CR>

" I don't understand below commands, what is <C-C> & <C-O> ?
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>


" Clearing whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

let g:peekup_paste_before = '<leader>P'
let g:peekup_paste_after = '<leader>p'

