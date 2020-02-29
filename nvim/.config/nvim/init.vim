"
" PREFERENCES
"

" 24-bit colors (may not need this?)
set termguicolors

" Line numbers
set number
set relativenumber

set ignorecase
set smartcase

" Enable copy to clipboard with yank, change, put, etc
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/vim/tmp/undo//
endif

" Save on build
set autowrite

" Change tab character to four spaces
filetype plugin indent on
" Show existing tabs as four spaces
set tabstop=4
" When indenting with >, use 4 spaces
set shiftwidth=4

" Hide buffers instead of closing them

set hidden

" Make , the leader, because \ is hard
let mapleader = ","

" add a line on the 80th column
set colorcolumn=80

" highlight the cursor's row
set cursorline


" Use only the quickfix list for go
let g:go_list_type = "quickfix"

" Enable the mouse (yes, I know)
set mouse=a

"
" KEY REMAPPINGS
"
"

" Editor

map <C-o> :NERDTreeToggle<CR>

" GoLang

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>


"
" PLUGINS
"

call plug#begin(stdpath('data') . '/plugged')

" Theme
Plug 'kaicataldo/material.vim'

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

Plug 'mhinz/vim-startify'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

" Someday... This could probably be replaced by the functionality provided by
" vim-startify
Plug 'tpope/vim-obsession'

Plug 'vim-airline/vim-airline'

" File browser
Plug 'scrooloose/nerdtree'

Plug 'sheerun/vim-polyglot'

" Quote, brackes, paren autoclosing
Plug 'Raimondi/delimitMate'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Add additional plugins here

call plug#end()


let g:airline_section_y = '%{ObsessionStatus()}'


"

" UTILS
"

" Colorscheme
let g:material_terminal_italics = 1

colorscheme material

" Reloads vimrc after saving but keep cursor position
if !exists('*ReloadVimrc')
   fun! ReloadVimrc()
       let save_cursor = getcurpos()
       source $MYVIMRC
       call setpos('.', save_cursor)
   endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()

