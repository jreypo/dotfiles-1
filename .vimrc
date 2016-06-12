" vim:foldmethod=marker


call plug#begin()

" Plug 'bling/vim-airline'
" let g:airline_powerline_fonts=1
" let g:airline_detect_spell=0
Plug 'itchyny/lightline.vim'
let g:lightline = {
    \ 'colorscheme': 'PaperColor',
    \ 'componene': {
    \  'readonly': '%{&readonly?"":""}',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

" Mirror vim status bar theme to tmux
Plug 'edkolev/tmuxline.vim'

" extended % matching for HTML, LaTeX, and many more languages
Plug 'vim-scripts/matchit.zip'


" Colorschemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'jdkanani/vim-material-theme'
Plug 'morhetz/gruvbox'


"{{{ ctrlp: File navigation
Plug 'ctrlpvim/ctrlp.vim'
"
" I'm almost always using vim with git anyway...
"
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -oc --exclude-standard']
let g:ctrlp_working_path_mode = ''
"}}}

Plug 'tpope/vim-vinegar'

" Surround text
Plug 'tpope/vim-surround'

" Commenting/uncommenting code
Plug 'tomtom/tcomment_vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'

" LESS Syntax highlighting, indent, and autocompletion
Plug 'groenewege/vim-less', { 'for': 'less' }

" Misc functions needed by other plugins
Plug 'xolox/vim-misc'

"{{{ syntastic: Syntax check for several languages
Plug 'scrooloose/syntastic', { 'for': 'python' }
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = ""
let g:syntastic_warning_symbol = ""
let g:syntastic_style_error_symbol = ""
let g:syntastic_style_warning_symbol = ""
let g:syntastic_always_populate_loc_list = 1

let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8']
"}}}


Plug 'SirVer/ultisnips'

Plug 'Konfekt/FastFold'
let g:fastfold_fold_command_suffixes =
            \['x','X','a','A','o','O','c','C','r','R','m','M','i','n','N']

" vim notes with dropbox storage {{{
Plug 'xolox/vim-notes'
let g:notes_directories = ['~/dropbox/vim-notes']
let g:notes_list_bullets = ['•', '▶', '▷', '◆']
let g:notes_tab_indents = 0
" }}}

"{{{ ag: the silver searcher
Plug 'rking/ag.vim'
nnoremap <leader>a :Ag<Space>
"}}}

" {{{ vimproc: Make it possible to execute programs within vim (requires compilation)

Plug 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
"}}}

Plug 'saltstack/salt-vim', { 'for': 'sls' }
"
" Python
"

" Better indentation for Python
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }


" Python matchit support
Plug 'voithos/vim-python-matchit', { 'for': 'python' }

" Highlighting for restructured text
Plug 'Rykka/riv.vim', { 'for': 'rst' }

Plug 'hdima/python-syntax', { 'for': 'python' }
"
" JavaScript
"
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" Vim as a tool for writing
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'

call plug#end()

filetype plugin indent on

" }}}

" Leaders {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" Key Mappings {{{

" Quick escape
inoremap jk <esc>

nnoremap <leader>p :CtrlP<cr>
nnoremap <leader>t :CtrlPTag<cr>

" Clear higlighting of words matching search
nnoremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Rebuild ctags
:nnoremap <silent> <F12> :echo "Rebuilding tags..."<cr>:!ctags .<cr>:echo "Rebuilt tags"<cr>

" Shortcut to edit .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" Set current directory to currently open file.
nnoremap <leader>cd :lcd %:p:h<cr>

" JSON Formatting
nnoremap <leader>js :%!python -m json.tool<cr>

" Browse directory of file in current buffer
nnoremap <leader>ex :Explore<cr>

" Search with ag
nnoremap <leader>a :Ag ""<left>

" Switch between dark and light background
nnoremap <leader>bd :set background=dark<cr>
nnoremap <leader>bl :set background=light<cr>
" }}}


" Options {{{
syntax on " Turn on syntax highlighting

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set autowrite           " Automatically save buffer
set number
set incsearch
set scrolloff=3         " keep 3 lines when scrolling
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set nowritebackup
set noswapfile
set hlsearch            " highlight searches
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present
set encoding=utf-8

"
" Easiear copy paste to system clipboard
"
set clipboard=unnamed


"
" Turn off error beeps and flashing
"
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set backspace=indent,eol,start  " make that backspace key work the way it should

"
" Patterns to ignore for ctrlp etc.
"
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.o,*.pyc
set wildignore+=*/node_modules/*,*/bower_components/*,*/venv/*,*/Python34/*

"
" If compiler error refers to a file already open in a window,
" use that window instead of opening the file in the last active
" window.
"
set switchbuf=useopen



" }}}

" Python Settings {{{

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
    " Prevent JEDI from showing docstrings automatically on autocomplete
    autocmd FileType python setlocal completeopt-=preview

    " We don't need smartindent in python. Makes comments always go to 
    " the start of the line.
    autocmd FileType python setlocal nosmartindent
augroup END


" {{{ Functions for running tests in python
function! RunTests(args)
    set makeprg=nosetests\ --with-terseout
    exec "make! " . a:args
endfunction

function! RunFlake()
    set makeprg=flake8
    exec "make!"
endfunction

function! JumpToError()
    if getqflist() != []
        for error in getqflist()
            if error['valid']
                break
            endif
        endfor
        let error_message = substitute(error['text'], '^ *', '', 'g')
        silent cc!
        if error['bufnr'] != 0
            exec ":sbuffer " . error['bufnr']
        endif
        call RedBar()
        echo error_message
    else
        call GreenBar()
        echo "All tests passed"
    endif
endfunction

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl None
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl None
endfunction"

nnoremap <leader>ra :wa<cr>:call RunTests("")<cr>:redraw<cr>:call JumpToError()<cr>
nnoremap <leader>rf :wa<cr>:call RunFlake()<cr>:redraw<cr>:call JumpToError()<cr>

" }}}

nnoremap <leader>rd :redraw!<cr>
" }}}

" Appearance {{{

"
" Only display trailing whitespaces when we're not in insert mode
"
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:◆
    au InsertLeave * :set listchars+=trail:◆
augroup END

if has('gui_running')
    set guioptions=-Mc

    if has('win32') || has('win64')
        set guifont=Source_Code_Pro_Medium:h10:cANSI
    elseif has('macunix')
        set guifont=Source\ Code\ Pro\ Medium:h16
    endif

else
    "
    " Make vim display colors and fonts properly
    "
    if has("win32unix") || has("macunix")
        set term=xterm-256color
        set t_ut=
    else
        set termencoding=ut8
        set term=xterm
        set t_Co=256
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
        let &t_ZH="\e[3m"
    endif
endif

set cursorline
if &background == 'light'
    highlight CursorLine cterm=NONE ctermbg=LightGray ctermfg=NONE
else
    highlight CursorLine cterm=NONE ctermbg=233 ctermfg=NONE
    highlight colorcolumn ctermbg=235
endif

highlight! link MatchParen StatusLine

set list                " Display special characters (e.g. trailing whitespace)
set listchars=tab:▷◆,trail:◆

" let g:rehash256 = 1
set background=light
colorscheme PaperColor

" }}}
