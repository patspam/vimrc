"
" Vim Config
" Patrick Donelan
"

"=====[ Pre Config ]==========================================================
set nocompatible
syntax on
silent! source ~/.vimrc-pre
silent! source ~/.vimrc-vundle
filetype plugin indent on
let mapleader = ";"

"=====[ General Settings ]====================================================
set autowrite " Automatically save before commands like :next and :make
set background=dark
set colorcolumn=+1
set hidden " Hide buffers when they are abandoned
set hlsearch
set ignorecase " Do case insensitive matching
set incsearch " Incremental search
set list " Special chars
set matchtime=1 " Default 5 is too slow (in 10ms)
set modeline
set mouse=a " Enable mouse usage (all modes)
set nocursorline " Causes a visible flicker, especially in visual mode
set showcmd " Show (partial) command in status line
set showmatch " Show matching brackets
set smartcase " Do smart case matching
set splitright
set synmaxcol=200 " Helps prevent vim from choking on long lines
set virtualedit=block "Square up visual selections
set wildmenu

"=====[ Stuff ]===============================================================

" .vimrc
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nmap <silent> <leader>v :next $MYVIMRC<CR>
au FileType vim setlocal textwidth=0

" Special Chars
nmap <silent> <leader># :set list!<CR>
set listchars=tab:▸\·,eol:¬,trail:\·,extends:»,precedes:«
highlight NonText ctermfg=DarkGrey
highlight SpecialKey ctermbg=0 ctermfg=DarkRed
" Demo: tab & trailing spaces should be red	text     

" Jump to most recent position in file
au BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
              \|    exe "normal! g`\""
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

" Persistent selection
vmap <silent> > >gv
vmap <silent> < <gv
vmap <silent> u <ESC>ugv
vmap <silent> <C-R> <ESC><C-R>gv

" Line width
au FileType java setlocal textwidth=100 colorcolumn=+1
au FileType javascript setlocal textwidth=80 colorcolumn=+1

" Vim's ftplugin/javascript.vim unsets the t flag (/usr/share/vim/vim73/ftplugin/javascript.vim)
au FileType javascript setlocal formatoptions+=t

" File changes
set autoread
au CursorHold,BufWinEnter * checktime

" Fix js syntax highlighting within html files (otherwise breaks after :e)
au BufEnter *.html :syntax sync fromstart

nnoremap <silent> <leader>c :execute "set colorcolumn=" . (&cc == "+1" ? "0" : "+1")<CR>
nnoremap <silent> <leader>u :Bufdo checktime<CR>
nnoremap <silent> <leader>p :set invpaste paste?<CR>
nnoremap <silent> <C-w><C-^> :vsplit #<CR>
nnoremap <silent> <Backspace> :nohlsearch<CR>
nnoremap <silent> <Leader>] :execute "silent! !ctags -R" <Bar> redraw!<CR>
nnoremap <silent> <leader>q :cw<CR>

" Search/Replace
nmap <leader>s :%s/\<<C-r><C-w>\>/
vmap s :s/

" Sorting
vmap so !sort<CR>

" Saving files
nmap <silent> <leader>w :w<CR>
nmap <silent> <leader>x :bd<CR>
command! W w " Probbly not necessary once my fingers learn the mapping above

" Alternate file
nmap <silent> <leader>a <C-^>
imap <silent> <C-^> <C-C>:e #<CR>

" One-handed scrolling
nmap <silent> <Space> <PageDown>
nmap <silent> <M-Space> <PageUp>

" Make
nnoremap <leader>m :silent make\|redraw!<CR>

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
      set colorcolumn=
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
nmap <silent> <leader>r :MRU<CR>

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
" nnoremap <silent> <buffer> <leader>i :JavaImport<cr>

" Foldsearch
" Toggle on/off
nmap <silent> <expr> <leader>z FS_ToggleFoldAroundSearch({'context':1})
" Show only JS function defs
nmap <silent> <expr> <leader>jsp FS_FoldAroundTarget('\S\+\.prototype\.\w\+',{'context':0})
nmap <silent> <expr> <leader>jsf FS_FoldAroundTarget('^\s\+function\s\+\w\+(',{'context':0})
nmap <silent> <expr> <leader>jsc FS_FoldAroundTarget('\S\+\.prototype\.\w\+\\|\/\/.*',{'context':0})
"nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1}) " Show only C #includes...

" Commentary
nmap <silent> <C-\> <Plug>CommentaryLine

" Matchit (bundled with vim)
:runtime macros/matchit.vim

" a.vim
nmap <silent> <leader>A :A<CR>
let g:alternateExtensions_M = "h" " Objective-c
let g:alternateDefaultMappings = 0

" ToggleList
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>

"=====[ Functions ]===========================================================

" Like bufdo but restore the current buffer.
" http://vim.wikia.com/wiki/Run_a_command_in_multiple_buffers#Restoring_position
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
command! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

nmap <silent> <CR> :call Enter()<CR>
function! Enter()
  if (&modifiable)
    execute "normal! mxi\<CR>\<Esc>`x"
  else
    execute "normal! \<CR>"
  endif
endfunction

" Post-config
silent! source ~/.vimrc-post
