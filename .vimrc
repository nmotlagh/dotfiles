" Enhanced Professional and Aesthetic Vim Configuration

set mouse=
set ttymouse=
" General Settings
set nocompatible
filetype plugin indent on
syntax enable
set encoding=utf-8
set hidden

" Aesthetic Settings
if has('termguicolors')
  set termguicolors
endif
colorscheme desert
set number relativenumber
set cursorline
set showmatch
set wrap
set laststatus=2
set noshowmode
set showcmd
set wildmenu

" Indentation Settings
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Search Settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" Performance Settings
set lazyredraw

" Functionality Improvements
set backspace=indent,eol,start
set scrolloff=3

" Key Mappings
let mapleader = " "
inoremap jj <Esc>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>n :set number!<CR>
nnoremap <Leader>c :nohlsearch<CR>

" Split Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Clipboard Integration
set clipboard=unnamed,unnamedplus

" Status Line Configuration
set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

" Git Branch in Status Line
function! StatuslineGit()
  let l:branchname = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Plugins (using vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Plugin Configurations
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'

" FZF Configuration
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Additional Aesthetic Enhancements
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set fillchars+=vert:│
highlight VertSplit cterm=NONE

" Color tweaks
highlight LineNr ctermfg=darkgrey
highlight CursorLineNr ctermfg=yellow
highlight StatusLine ctermbg=darkgrey ctermfg=white
highlight StatusLineNC ctermbg=black ctermfg=lightgrey
highlight VertSplit ctermbg=darkgrey ctermfg=darkgrey
highlight Visual ctermbg=black ctermfg=lightgrey

" PuTTY-specific settings
if &term =~ "xterm"
    let &t_SI = "\<Esc>[5 q"
    let &t_EI = "\<Esc>[2 q"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    function XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
