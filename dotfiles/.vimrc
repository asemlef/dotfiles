execute pathogen#infect()

filetype plugin indent on
syntax enable

" indentation settings
set tabstop=4
set shiftwidth=4
set expandtab
autocmd BufRead,BufNewFile *.rb setlocal ts=2 sw=2

" buffer settings
set hidden
set confirm

" search settings
set ignorecase
set smartcase

" airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" nerdtree settings
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" tagbar settings
nmap <F8> :TagbarToggle<CR>
