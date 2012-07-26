"
" Vim Config
" Patrick Donelan
"

"=====[ Pre Config ]==========================================================
set nocompatible
syntax on
silent! source ~/.vimrc-pre
call pathogen#infect() " Needs to happen before :filetype plugin indent on
filetype plugin indent on
let mapleader = ";"

"=====[ General Settings ]====================================================
set autowrite " Automatically save before commands like :next and :make
set background=dark
set cursorline
set hidden " Hide buffers when they are abandoned
set hlsearch
set ignorecase " Do case insensitive matching
set incsearch " Incremental search
set modeline
set mouse=a " Enable mouse usage (all modes)
set showcmd " Show (partial) command in status line
set showmatch " Show matching brackets
set smartcase " Do smart case matching
set splitright
set synmaxcol=200 " Helps prevent vim from choking on long lines
set virtualedit=block "Square up visual selections
set wildmenu

"=====[ Stuff ]===============================================================

" Objective C
"let g:filetype_m = "objc"

" .vimrc
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nmap <silent> <leader>v :next $MYVIMRC<CR>

" Special Chars
nmap <silent> <leader>x :set list!<CR>
set listchars=tab:▸\·,eol:¬,trail:\·,extends:»,precedes:«
highlight NonText ctermfg=DarkGrey
highlight SpecialKey ctermbg=0 ctermfg=DarkRed " Demo: tab & trailing spaces should be red	text     

" Jump to most recent position in file
autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif

" Persistent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  set undolevels=5000
  set undofile
endif

" Tabs
set expandtab
set shiftwidth=2 " Autoindent width
set softtabstop=2 " BS deletes 2 spaces
set tabstop=8 " Make unwanted tabs easy to spot

" Line width
au FileType java setlocal textwidth=120 colorcolumn=+1
au FileType javascript setlocal textwidth=80 colorcolumn=+1

" Vim's ftplugin/javascript.vim unsets the t flag (/usr/share/vim/vim73/ftplugin/javascript.vim)
au FileType javascript setlocal formatoptions+=t

" File changes
set autoread
au CursorHold,BufWinEnter * checktime

" Fix js syntax highlighting within html files (otherwise breaks after :e)
au BufEnter *.html :syntax sync fromstart

nnoremap <C-Left> :lprevious<CR>
nnoremap <C-Right> :lnext<CR>
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprevious<CR>
nnoremap <CR> mxi<CR><Esc>`x
nnoremap <leader>c :execute "set colorcolumn=" . (&cc == "+1" ? "0" : "+1")<CR>
nnoremap <leader>r :vertical resize 82<CR>
nnoremap <leader>u :Bufdo checktime<CR>
nnoremap <leader>p :set invpaste paste?<CR>
nnoremap <C-w><C-^> :vsplit #<CR>
nnoremap <Backspace> :nohlsearch<CR>
nnoremap <silent> <Leader>] :execute "silent! !ctags -R" <Bar> redraw!<CR>

" Search/Replace
nmap <leader>s :%s/\<<C-r><C-w>\>/
vmap s :s/

" Sorting
vmap so !sort<CR>

" Saving files
nmap <leader>w :w<CR>
command! W w " Probbly not necessary once my fingers learn the mapping above

" Alternate file
nmap <leader>a <C-^>
imap <C-^> <C-C>:e #<CR>

" One-handed scrolling
nmap <Space> <PageDown>
nmap <M-Space> <PageUp>

" Vimdiff
" highlight DiffAdd cterm=bold ctermfg=green ctermbg=NONE guibg=NONE
" highlight DiffChange cterm=bold ctermfg=cyan ctermbg=NONE guibg=NONE
" highlight DiffText cterm=bold ctermfg=gray ctermbg=NONE guibg=NONE
" highlight DiffDelete cterm=bold ctermfg=red ctermbg=NONE guibg=NONE

" Help in new tab
augroup HelpInTabs
  autocmd!
  autocmd BufEnter *.txt call HelpInNewTab()

  function! HelpInNewTab ()
    if &buftype == 'help'
      execute "normal \<C-W>T"
    endif
  endfunction
augroup END

"=====[ Plugins ]=============================================================

" NERDTree
nnoremap <silent> <Leader>d :NERDTreeToggle<CR>
nnoremap <silent> <Leader>f :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1

" CtrlP
noremap <silent> <leader>b :CtrlPBuffer<CR>
let g:ctrlp_working_path_mode = 0 " Don't muck with $PWD
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll$',
  \ }
let g:ctrlp_max_files = 50000
let g:ctrlp_by_filename = 0 " Search by filename instead of path by default
let g:ctrlp_max_height = 20

" LustyJuggler
let g:LustyJugglerDefaultMappings = 0
nmap <silent> <leader>l :LustyJuggler<CR>

" MRU
nmap <silent> <leader>m :MRU<CR>

" Ack
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Powerline
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
let g:Powerline_stl_path_style="short"
let g:Powerline_symbols="fancy"

" TagBar
nnoremap <silent> <Leader>t :TagbarToggle<CR>
let g:tagbar_autoclose=1

" Fugitive
" set laststatus=2
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P " Vim default
" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Eclim
" let g:EclimJavaSearchSingleResult='edit'
" au Filetype java nnoremap <silent> <Leader>g :JavaSearchContext<CR>
" au Filetype java nnoremap <silent> <Leader>r :JavaSearch -x reference<CR>

" Foldsearch
" Toggle on/off
nmap <silent> <expr> <leader>z FS_ToggleFoldAroundSearch({'context':1})
" Show only JS function defs
nmap <silent> <expr> <leader>js FS_FoldAroundTarget('\S\+\.prototype\.\w\+',{'context':1})
nmap <silent> <expr> <leader>ja FS_FoldAroundTarget('\S\+\.prototype\.\w\+\\|\/\/.*',{'context':1})
" Show only C #includes...
"nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})


"=====[ Functions ]===========================================================

" Like bufdo but restore the current buffer.
" http://vim.wikia.com/wiki/Run_a_command_in_multiple_buffers#Restoring_position
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
command! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Post-config
silent! source ~/.vimrc-post
