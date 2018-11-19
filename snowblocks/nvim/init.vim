" ------------------------------
" Python Environment
" ------------------------------
if has('nvim') && isdirectory($HOME."/.local/share/pyenv/versions/dotfiles")
    let g:python3_host_prog = $HOME."/.local/share/pyenv/versions/dotfiles/bin/python"
endif

" ------------------------------
" Vim Compatibility
" ------------------------------
if !has('nvim')
    " force vim to use the right paths
    set runtimepath^=~/.config/nvim runtimepath+=~/.local/share/nvim/site runtimepath+=~/.config/nvim/after
    if v:version >= 800
        let &packpath = &runtimepath
    endif

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

    " Allow color schemes to do bright colors without forcing bold.
    if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
      set t_Co=16
    endif

    " create swap, backup, and undo directories if absent
    if !isdirectory($HOME."/.local/share/nvim/backup")
        call mkdir($HOME."/.local/share/nvim/backup", "p")
    endif
    if !isdirectory($HOME."/.local/share/nvim/swap")
        call mkdir($HOME."/.local/share/nvim/swap", "p")
    endif
    if !isdirectory($HOME."/.local/share/nvim/undo")
        call mkdir($HOME."/.local/share/nvim/undo", "p")
    endif

    " misc settings
    set ttymouse=xterm2     " improved mouse drag handling
endif

" ------------------------------
" Plugins
" ------------------------------
" install vim-plug if absent
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | q
endif

" install and configure plugins
call plug#begin('~/.local/share/nvim/plugged')

    " solarized color theme
    Plug 'lifepillar/vim-solarized8'

    " git wrapper for vim
    Plug 'tpope/vim-fugitive'

    " show which lines have been modified in git
    Plug 'airblade/vim-gitgutter'

    " Fuzzy path finder
    Plug 'ctrlpvim/ctrlp.vim'

    " Highlight and strip trailing whitespace
    Plug 'ntpeters/vim-better-whitespace'

    " Simple text alignment
    Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }

    " Undo tree browser
    Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
    "autocmd! User gundo.vim echom 'gundo is now loaded!'
    if has('python3')
        let g:gundo_prefer_python3=1
    endif
    nnoremap <leader>g :GundoToggle<CR>

    " File tree browser
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
    map <C-n> :NERDTreeToggle<CR>

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
    if !has('nvim')
        Plug 'tmux-plugins/vim-tmux-focus-events'
    endif

    " Autocompletion for various languages
    if has('python3') && (v:version >= 800 || has('nvim'))
        " Autocompletion tool
        if has('nvim')
            Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        else
            Plug 'Shougo/deoplete.nvim'
            Plug 'roxma/nvim-yarp'
            Plug 'roxma/vim-hug-neovim-rpc'
        endif
        let g:deoplete#enable_at_startup = 1
        " Java
        Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
        autocmd FileType java setlocal omnifunc=javacomplete#Complete
        " Python
        Plug 'zchee/deoplete-jedi', { 'for': 'python' }
        " Ruby
        Plug 'fishbullet/deoplete-ruby', { 'for': 'ruby' }
        " Vim
        Plug 'Shougo/neco-vim', { 'for': 'vim' }
    elseif has('nvim')
        autocmd VimEnter * echohl WarningMsg | echom "python3 missing!" | echohl None
    endif

    " Syntax checking for various languages
    Plug 'vim-syntastic/syntastic'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_aggregate_errors = 1

    " Additional filetypes
    Plug 'saltstack/salt-vim'   " SaltStack .sls files
    Plug 'chr4/nginx.vim'       " nginx config files

call plug#end()

" automatically install any new plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | q
endif

" ------------------------------
" Navigation
" ------------------------------
set mouse=a         " enable mouse for all modes
set scrolloff=3     " keep 3 lines visible when scrolling

" ------------------------------
" Editing
" ------------------------------
set backspace=indent,eol,start  " backspace works on everything
set nrformats-=octal            " don't parse octal numbers for addition/subtraction
set complete-=i                 " don't scan included files for word completion

" ------------------------------
" Style
" ------------------------------
set laststatus=2        " always show status bar
set showbreak=↪         " indicator for lines that have been wrapped
"set list                " always show unprintable characters
set listchars=tab:▸\ ,trail:•,extends:›,precedes:‹,eol:↲,nbsp:␣
if v:version >= 800 || has('nvim')
    set termguicolors       " use 24-bit colors
endif

" if solarized theme is present, use it
if isdirectory($HOME."/.local/share/nvim/plugged/vim-solarized8")
    set background=dark
    colorscheme solarized8
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
" Buffers
" ------------------------------
set hidden  " allow switching from modified buffers
set confirm " prompt for confirmation when quitting with unsaved changes

" ------------------------------
" Search
" ------------------------------
set hlsearch    " highlight search terms
set ignorecase  " ignore letter case
set smartcase   " DON'T ignore letter case if capitals are present
set incsearch   " search as you type

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" ------------------------------
" Backup & Swap
" ------------------------------
set nobackup    " do not create a permanent backup of a file when writing
set writebackup " create a temporary backup of a file when writing
set undofile    " keep persistent undo history
set backupdir=.,~/.local/share/nvim/backup      " backup files are created here
set directory=~/.local/share/nvim/swap//        " swap files are stored here
set undodir=~/.local/share/nvim/undo            " undo files are stored here

" ------------------------------
" Command
" ------------------------------
set showcmd         " show commands in the bottom right as they're typed
set history=1000    " keep 1000 commands in history
set wildmenu        " enable command completion menu

" ------------------------------
" Copy/Paste
" ------------------------------
" Copy yank buffer to system clipboard
" Use OSC52 to put things into the system clipboard, works over SSH!
function! Osc52Yank()
    if has('macunix')
        let buffer=system('base64', @0)
    else
        let buffer=system('base64 -w0', @0)
    endif
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer="\e]52;c;".buffer."\x07"

    " Need special escaping if within tmux
    if $TMUX != ''
        let buffer="\ePtmux;\e".buffer."\e\\"
    endif

    " Must output to /dev/tty, otherwise the escape codes don't make it out to
    " the terminal
    if has('nvim')
        call chansend(v:stderr, buffer)
    elseif v:version >= 800
        silent exe "!echo -ne ".shellescape(buffer)." > /dev/tty"
        redraw!
    else
        silent exe "!echo -ne ".shellescape(buffer)." > /dev/tty"
    endif
endfunction

command! Osc52CopyYank call Osc52Yank()

" Copy yank register to system
nnoremap <leader>y :Osc52CopyYank<cr>
" Copy selection to system clipboard
vnoremap <leader>y :<C-u>norm! gvy<cr>:Osc52CopyYank<cr>
