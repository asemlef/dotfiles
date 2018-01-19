set nocompatible

" ------------------------------
" Plugins
" ------------------------------
" install and configure plugins
call plug#begin('~/.local/share/nvim/plugged')

    " solarized colors
    Plug 'altercation/vim-colors-solarized'

    " git wrapper for vim
    Plug 'tpope/vim-fugitive'

    " show which lines have been modified in git
    Plug 'airblade/vim-gitgutter'

    " Fuzzy path finder
    Plug 'ctrlpvim/ctrlp.vim'

    " Highlight trailing whitespace
    Plug 'ntpeters/vim-better-whitespace'

    " Undo tree browser
    Plug 'sjl/gundo.vim'
    " Add keybind for gundo here

    " File tree browser
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    map <C-n> :NERDTreeToggle<CR>
    " automatically close vim if nerdtree is only window
    "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Better status line
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_powerline_fonts=1
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='dark'
    let g:airline#extensions#tabline#enabled=1
    let g:airline#extensions#tabline#buffer_idx_mode=1
    " use backslash + # to navigate between tabs
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9

    " Tag browser (requires exuberant ctags)
    Plug 'majutsushi/tagbar'
    nmap <F8> :TagbarToggle<CR>

    " Fancy icons for airline, nerdtree, ctrl-p
    Plug 'ryanoasis/vim-devicons'

    " Fix FocusGained and FocusLost events while in tmux
    Plug 'tmux-plugins/vim-tmux-focus-events'

    " Use tmux clipboard and share clipboard between nvim sessions
    "Plug 'roxma/vim-tmux-clipboard'

call plug#end()

" automatically install any new plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugUpdate --sync | source $MYVIMRC | q
endif

" ------------------------------
" Style
" ------------------------------
set laststatus=2        " always show status bar
set showbreak=↪         " indicator for lines that have been wrapped
"set list                " always show unprintable characters
set listchars=tab:▸\ ,trail:•,extends:›,precedes:‹,eol:↲,nbsp:␣
set mouse=a             " enable mouse for all modes
"set ttymouse=xterm2     " improved mouse drag handling

" ------------------------------
" Editing
" ------------------------------
set backspace=indent,eol,start  " backspace works on everything
set nrformats-=octal            " don't parse octal numbers for addition/subtraction
set complete-=i                 " don't scan included files for word completion
"set formatoptions-=cro          " disable automatically adding comments on new lines

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j " Delete comment character when joining commented lines
endif

" automatically set paste mode when pasting
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

" -------------------------------------
"  Text
" -------------------------------------
set scrolloff=3         " keep 3 lines visible when scrolling

" if solarized theme is present, use it
if isdirectory($HOME."/.local/share/nvim/plugged/vim-colors-solarized")
    set background=dark
    colorscheme solarized
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" -------------------------------------
"  Tab & Indentation
" -------------------------------------
set expandtab       " convert tabs to spaces
set autoindent      " automatically indent new lines
set tabstop=4       " tabs are 4 spaces wide
set shiftwidth=4    " indenting shifts 4 spaces

" for ruby, use 2 spaces
autocmd Filetype ruby setlocal ts=2 sw=2

" ------------------------------
" Buffer
" ------------------------------
set hidden  " allow switching from modified buffers
set confirm " prompt for confirmation when quitting with unsaved changes

" ------------------------------
" Search
" ------------------------------
set hlsearch    " highlight search terms
set ignorecase  " ignore letter case
set smartcase   " DON'T ignore letter case if capitals are present

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" ------------------------------
" Backup & Swap
" ------------------------------
set nobackup
"set backupdir=~/.vim-tmp/bak,/tmp   " backup files are created here
"set directory=~/.vim-tmp/swps//     " all swap files are stored here

" create swap and backup directories if absent
"if !isdirectory($HOME."/.vim-tmp/swps")
"    call mkdir($HOME."/.vim-tmp/swps", "p")
"endif
"if !isdirectory($HOME."/.vim-tmp/bak")
"    call mkdir($HOME."/.vim-tmp/bak", "p")
"endif

" ------------------------------
" Command
" ------------------------------
set showcmd         " show commands in the bottom right as they're typed
set history=1000    " keep 1000 commands in history

" ------------------------------
" Copy/Paste
" ------------------------------
" Copy yank buffer to system clipboard
" Use OSC52 to put things into the system clipboard, works over SSH!
function! Osc52Yank()
  let buffer=system('base64 -w0', @0)
  let buffer=substitute(buffer, "\n$", "", "")
  let buffer='\e]52;c;'.buffer.'\x07'

  " Need special escaping if within tmux
  if $TMUX != ''
    let buffer='\ePtmux;\e'.buffer.'\e\\'
  endif

  " Must output to /dev/tty, otherwise the escape codes don't make it out to the
  " terminal
  silent exe "!echo -ne ".shellescape(buffer)." > /dev/tty"
endfunction

command! Osc52CopyYank call Osc52Yank()

" Copy yank register to system
nnoremap <leader>y :Osc52CopyYank<cr>
" Copy selection to system clipboard
vnoremap <leader>y :<C-u>norm! gvy<cr>:Osc52CopyYank<cr>
"vnoremap y :<C-u>norm! gvy<cr>:Osc52CopyYank<cr>

" ------------------------------
" Misc
" ------------------------------
set wildmenu
" these fix some weird issues with airline and tagbar
autocmd VimEnter * redraw!