" vim:foldmethod=marker

" Windows Runtime ---------------------------------{{{
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
    let $PATH .= ';' . 'c:\Python33;c:\Python33\scripts'
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set renderoptions=type:directx,gamma:1.0,contrast:0.9,level:1.0,geom:1,renmode:5,taamode:1

    "
    " Make UltiSnips edit snippets file in the correct directory.
    "
    let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

endif
" }}}

" Setting up NeoBundle --------------------------------------------------{{{
if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
" }}}

" Plugins ----------------------------------------------------------------{{{
NeoBundleFetch 'Shougo/neobundle.vim'

" Better status bar
NeoBundle 'bling/vim-airline'

" extended % matching for HTML, LaTeX, and many more languages
NeoBundle 'vim-scripts/matchit.zip'


" Colorschemes
NeoBundle 'nielsmadan/harlequin'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'sickill/vim-monokai'

" File navigation
NeoBundle 'kien/ctrlp.vim.git'
" NeoBundle 'blueyed/nerdtree.git'  Let's try netrw instead...
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/neomru.vim.git'
NeoBundle 'junkblocker/unite-codesearch'

" Add support for local vimrc files (.lvimrc)
NeoBundle 'embear/vim-localvimrc.git'

" Surround text
NeoBundle 'tpope/vim-surround.git'

" Change font size with +/- keys
NeoBundle 'thinca/vim-fontzoom.git'

" Commenting/uncommenting code
NeoBundle 'tomtom/tcomment_vim.git'

" Git integration
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'int3/vim-extradite.git'

" LESS Syntax highlighting, indent, and autocompletion
NeoBundle 'groenewege/vim-less.git'

" Misc functions needed by other plugins
NeoBundle 'xolox/vim-misc.git'

" Improved integration between Vim and its environment (fullscreen, open URL, background command execution)
NeoBundle 'xolox/vim-shell'

NeoBundle 'rking/ag.vim'

" Syntax check for several languages
NeoBundle 'scrooloose/syntastic.git'

NeoBundle 'SirVer/ultisnips'

" Personal Wiki for Vim
NeoBundle 'vimwiki/vimwiki'

" Distraction free writing
NeoBundle 'junegunn/goyo'

" 
" Make it possible to execute programs within vim (requires compilation)
"
execute "NeoBundle 'Shougo/vimproc.vim'," . string({
      \ 'directory': 'vimproc',
      \ 'build' : {
      \     'windows' : 'call "%ProgramFiles(x86)%\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64 && nmake -f make_msvc.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ })


"
" Python
"

" Better indentation for Python
NeoBundle 'hynek/vim-python-pep8-indent.git'

" Python matchit support
NeoBundle 'voithos/vim-python-matchit'

" Highlighting for restructured text
NeoBundle 'Rykka/riv.vim'


"
" JavaScript
"
NeoBundleLazy 'pangloss/vim-javascript'
au FileType javascript NeoBundleSource vim-javascript

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}

" Leaders {{{
let mapleader=","
let maplocalleader="\\"
highlight colorcolumn ctermbg=235
" }}}

" Key Mappings {{{

" Quick escape
inoremap jk <esc>

nnoremap <leader>p :CtrlPCurWD<cr>
nnoremap <leader>t :CtrlPTag<cr>
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>r :NERDTreeFind<cr>

" Clear higlighting of words matching search
nnoremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Rebuild ctags
:nnoremap <silent> <F12> :echo "Rebuilding tags..."<cr>:VimProcBang ctags -R .<cr>:echo "Rebuilt tags"<cr>

" Shortcut to edit .vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" Ack
nnoremap <leader>a :Ag ""<left>
let g:ag_mapping_message=0

" JSON Formatting
nnoremap <leader>js :%!python -m json.tool<cr>

" Kill all buffers
nnoremap <silent> <leader>kb :bufdo bw<cr>

nnoremap <leader>ex :Explore<cr>

" Take over Fontzoom's default mappings
let g:fontzoom_no_default_key_mappings=1

nnoremap <leader>= :Fontzoom +1<cr>
nnoremap <leader>- :Fontzoom -1<cr>

" Unite

" Use ag for search
let g:unite_source_grep_command = 'ag'
let g:unite_source_rec_async_command = 'ag'
let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
let g:unite_source_grep_recursive_opt = ''

let g:unite_source_history_yank_enable = 1
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>f :<C-u>Unite -start-insert -auto-resize file file_mru buffer<CR>
nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>


" }}}

" VimWiki with dropbox as storage {{{

if has('win32') || has('win64')
    let dropbox_path = $HOME . "/Dropbox"
else
    let dropbox_path = "~/Dropbox"
endif


let g:vimwiki_list = [{'path': dropbox_path . '/vimwiki/main/src', 'path_html': dropbox_path . '/vimwiki/main/html'}]
" }}}

" Options {{{
syntax on " Turn on syntax highlighting

set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
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
let NERDTreeIgnore = ['\.pyc$']

"
" Automatically load local vimrc files
"
let g:localvimrc_ask = 0

"
" If compiler error refers to a file already open in a window,
" use that window instead of opening the file in the last active
" window.
"
set switchbuf=useopen



" }}}

" Python Settings {{{
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8', 'pyflakes']

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
augroup END
" }}}

" Appearance {{{

if has('gui_running')
    set guioptions=-M

    if has('win32') || has('win64')
        set guifont=Source_Code_Pro_Medium:h11:cANSI
    elseif has('macunix')
        set guifont=Source\ Code\ Pro\ Medium:h16
    endif

    let g:airline_powerline_fonts = 1


    set list                " Display special characters (e.g. trailing whitespace)
    set listchars=tab:▷◆,trail:◆

    augroup trailing
        au!
        au InsertEnter * :set listchars-=trail:◆
        au InsertLeave * :set listchars+=trail:◆
    augroup END

    set background=dark

else
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    let &t_ZH="\e[3m"
endif
colorscheme gruvbox
set cursorline
if &background == 'light'
    highlight CursorLine cterm=NONE ctermbg=LightGray ctermfg=NONE
else
    highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE
endif
" }}}
