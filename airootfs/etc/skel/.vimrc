"" 
"" PNM OS VIM CONFIG
""

set nocompatible
filetype on
filetype indent on
syntax enable
set title
set bs=2
set mouse=a
set number
set tabstop=4
set expandtab
set nobackup
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=1100
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set encoding=utf-8




+" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin()

    Plug 'https://github.com/dense-analysis/ale'
    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/preservim/nerdtree'
    Plug 'https://github.com/vim-airline/vim-airline'
    Plug 'https://github.com/vim-airline/vim-airline-themes'
    Plug 'https://github.com/vim-syntastic/syntastic'           
    Plug 'https://github.com/airblade/vim-gitgutter'
    Plug 'https://github.com/kien/ctrlp.vim'
    Plug 'https://github.com/Yggdroot/indentLine'

    "" Languages and File Types "" 

     Plug 'https://github.com/vim-scripts/c.vim'
     Plug 'https://github.com/ervandew/supertab'
     Plug 'cakebaker/scss-syntax.vim'
     Plug 'chr4/nginx.vim'
     Plug 'chrisbra/csv.vim'
     Plug 'ekalinin/dockerfile.vim'
     Plug 'fatih/vim-go'
     Plug 'cespare/vim-toml', { 'branch': 'main' }
     Plug 'godlygeek/tabular' | Plug 'tpope/vim-markdown'
     Plug 'lifepillar/pgsql.vim'
     Plug 'othree/html5.vim'
     Plug 'tpope/vim-git'
     Plug 'tpope/vim-liquid'
     Plug 'tpope/vim-rails'
     Plug 'vim-python/python-syntax'
     Plug 'vim-ruby/vim-ruby'


set encoding=utf-8      
    

    call plug#end()

    " }}}



" SCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END


""solarized colorscheme

set background=dark "or light
colorscheme solarized
let g:solarized_termcolors=256

""nerdtree

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

syn match NERDTreeClosable #\~\<#
syn match NERDTreeClosable #\~\.#
syn match NERDTreeOpenable #+\<#
syn match NERDTreeOpenable #+\.#he=e-1

""airline

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
set t_Co=256
let g:airline_powerline_fonts = 1 
    
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
 

""ale

let g:airline#extensions#ale#enabled = 1
let g:syntastic_python_checkers = ['pylint']



"" vim gitgutter

let g:gitgutter_enabled = 1

"" syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']



"" clang 

let g:clang_library_path='/usr/lib/llvm/12/lib64/'
let g:clang_user_options='|| exit 0'
let g:clang_complete_auto = 0
let g:clang_compelte_macros=1
let g:clang_complete_copen = 0
let g:clang_debug = 1
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='clang_complete'
let g:clang_auto_select = 1
let g:clang_use_library = 1
let g:clang_complete_optional_args_in_snippets = 1


"" identline

let g:indentLine_char='|'

" }}}
