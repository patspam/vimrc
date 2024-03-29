"
" Vim Config
" Patrick Donelan
"
"=====[ Pre Config ]==========================================================
" Vundle stanza (part 1)
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

silent! source ~/.vimrc-vundle
silent! source ~/.vimrc-osx-pre

" Vundle stanza (part 2)
call vundle#end()
filetype plugin indent on

syntax on

"=====[ General Settings ]====================================================
set autowrite " Automatically save before commands like :next and :make
set background=dark
set colorcolumn=+1
" set completeopt-=preview
set hidden " Hide buffers when they are abandoned
set hlsearch
set ignorecase " Do case insensitive matching
set incsearch " Incremental search
set list " Special chars
set matchtime=1 " Default 5 is too slow (in 10ms)
set modeline
set mouse=a " Enable mouse usage (all modes)
set showcmd " Show (partial) command in status line
set showmatch " Show matching brackets
set smartcase " Do smart case matching
set splitbelow
set splitright
set synmaxcol=400 " Helps prevent vim from choking on long lines
set virtualedit=block " Square up visual selections
set wildmenu
set formatoptions+=j " Remove comment leader when joining lines
set nostartofline " Don't move cursor to start of line when switching buffers

" Leader
let mapleader = ";"
nnoremap <silent> <space> ;

" Swap & Undo
silent !mkdir ~/.vim/{swap,undo} > /dev/null 2>&1
set directory=~/.vim/swap// " Double-slash ensures %filepath%separation%
set undodir=~/.vim/undo
set undolevels=5000
set undofile

" Color scheme
" Set early so that rest of config can override as desired.
" Use base16 to inherit from terminal theme
" colorscheme base16-default-dark " https://github.com/chriskempson/base16-vim

"=====[ Stuff ]===============================================================

" .vimrc
augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nmap <silent> <leader>ev :next $MYVIMRC<CR>

" Special Chars
nmap <silent> <tab># :set list!<CR>
set listchars=tab:▸\·,eol:¬,trail:\·,extends:»,precedes:«
" highlight NonText ctermfg=239 guifg=DarkGrey
" highlight SpecialKey ctermbg=0 ctermfg=DarkRed guibg=black guifg=DarkRed
" Demo: tab & trailing spaces should be red	text     

" Typos
command! -bang Q q<bang>
command! -bang -nargs=? -complete=file E e<bang> <args>

nnoremap <leader>h :vert help 

" Visual mode highlight
" highlight CursorLine term=bold cterm=bold guibg=Grey40

" SignColumn (gutter)
set signcolumn=yes
highlight SignColumn ctermbg=Black
au BufEnter * sign define dummy
au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" Diff colours (also used by sign column plugins)
" highlight DiffAdd ctermbg=233 ctermfg=2 guifg=#009900
" highlight DiffChange ctermbg=233 ctermfg=3 guifg=#bbbb00
" highlight DiffDelete ctermbg=233 ctermfg=1 guifg=#ff2222

" GitGutter
let g:gitgutter_diff_args = ''
let g:gitgutter_realtime = 0 " Only update on save
let g:gitgutter_set_sign_backgrounds = 1
nnoremap <tab>g :let g:gitgutter_diff_args = ''<left>
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
" nmap <Leader>hs <Plug>GitGutterStageHunk
" nmap <Leader>hr <Plug>GitGutterRevertHunk

" Git
nmap <Leader>g :!git 

" Colours
" hi VertSplit ctermfg=233 ctermbg=239 " NB. dotted grey line drawn in bg colour

" CursorLine
" nnoremap <Leader>c :set cursorline!<CR>
" hi CursorLine cterm=underline

" Jump to most recent position in file
au BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
              \|    exe "normal! g`\""
              \|  endif

" Fix Shift+Arrow keys when TERM=screen-256color
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
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
au FileType bzl,javascript,java,c,cs,cpp,objc,objcpp setlocal textwidth=100 colorcolumn=+1
au FileType vim setlocal textwidth=0
au FileType markdown setlocal textwidth=80

" Python
au FileType python setlocal shiftwidth=2 softtabstop=2 tabstop=8 textwidth=80

" Auto-increment
" Use <c-A> a

" Objective-C
au FileType objc,objcpp nnoremap <buffer> <leader>jl :cexpr system(g:objclinter . " " . expand("%"))<cr>
au FileType objcpp set ft=objc
au BufRead,BufNewFile *.mm set ft=objc

" Markdown
au BufNewFile,BufRead *.md set ft=markdown

" Dosini
" au FileType conf set ft=dosini

" File changes
set autoread
au CursorHold,BufWinEnter * checktime

" Fix js syntax highlighting within html files (otherwise breaks after :e)
au BufEnter *.html :syntax sync fromstart

nnoremap <silent> <tab>c :execute "set colorcolumn=" . (&cc == "+1" ? "0" : "+1")<CR>
nnoremap <silent> <leader>u :Bufdo checktime<CR>
nnoremap <silent> <C-w><C-^> :vsplit #<CR>
nnoremap <silent> <Backspace> :nohlsearch<CR>:echo<CR>
nnoremap <silent> <Leader>] :execute "silent! !ctags -R" <Bar> redraw!<CR>
nnoremap <silent> <leader>q :cw<CR>

" Search/Replace
nmap <leader>~ :%s/\<<C-r><C-w>\>/
" vmap ~ :s/

" Sorting
vmap gs :sort<CR>
map sb vip:sort<CR>
map s) vi):sort<CR>
map s] vi]:sort<CR>
map s} vi}:sort<CR>

" Reflow
map qb vipgq

" Saving files
nmap <silent> <leader>w :w<CR>
nmap <silent> <leader>x :BD<CR>
nmap <silent> <leader>X :bd<CR>

" Alternate file
" nmap <silent> <leader>a <C-^>
nmap <silent> <leader>a <leader>lss
" imap <silent> <C-^> <C-C>:e #<CR>

" One-handed scrolling
" nmap <silent> <Space> <PageDown>
" nmap <silent> <M-Space> <PageUp>

" Select last pasted/modified text (from vim.wikia.com)
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Expand width of window to length of largest line (handy for NERDTree)
nnoremap <silent> z\| :execute "vertical resize " . (max(map(getline(1, '$'), 'len(v:val)')) + 1)<cr>

nnoremap <leader>v :vsplit<cr>

" Italics
set t_ZH=[3m
set t_ZR=[23m
highlight Comment cterm=italic

" Scrollfix
let g:scrollfix = -1  " Enable on demand via :FIX 60 (and diable via :FIXOFF)
let g:scrollinfo = 0

"=====[ Plugins ]=============================================================

" NERDTree
nnoremap <silent> <tab><tab> :NERDTreeToggle<CR>
" nnoremap <silent> <tab>f :NERDTreeFind<CR>
nnoremap <silent> <tab>f :exe ':NERDTree ' . expand('%:p:h')<CR> :NERDTreeFind<CR>
let NERDTreeShowBookmarks=0
let NERDTreeCaseSensitiveSort=1
let NERDTreeIgnore=['\.pyc$', '\~$', '\.git$', '\.gypd$'] " Toggle filtering via default f keybinding

" CtrlP
let g:ctrlp_map = '<leader>o'
nnoremap <leader>m :CtrlPMRUFiles<CR>
let g:ctrlp_clear_cache_on_exit = 0 " Only refresh on explicit <F5>
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_lazy_update = 50
let g:ctrlp_max_files = 0
let g:ctrlp_max_height = 20
let g:ctrlp_mruf_relative = 1
let g:ctrlp_working_path_mode = 0 " Don't muck with $PWD
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
    \ --ignore .git
    \ --ignore .svn
    \ --ignore .hg
    \ --ignore .DS_Store
    \ --ignore **/*.pyc
    \ --skip-vcs-ignores
    \ -g ""'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Ag
let g:ag_prg='ag --column'
nmap <leader>f :Ag  <C-R>=expand("%:h")<CR><C-B><Right><Right><Right>

" LustyJuggler
let g:LustyJugglerDefaultMappings = 0
nmap <silent> <leader>l :LustyJuggler<CR>

" Ack / Ag
" let g:ackprg="ack-grep -H --nocolor --nogroup --column"
" set grepprg=ag\ --nogroup\ --nocolor

" Airline
set laststatus=2  " Always show the statusline
set noshowmode
set ttimeoutlen=50  " Map timeout (fixes airline delay on leaving insert mode)
let g:airline_inactive_collapse = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

" TagBar
" nnoremap <silent> <tab>o :TagbarToggle<CR>
" let g:tagbar_autoclose=1

" Misc TAB toggles
nnoremap <silent> <tab>r :registers<CR>
nnoremap <silent> <tab>b :ls<CR>

" Commentary
nmap <silent> <C-\> <Plug>CommentaryLine
au Filetype c,cs,cpp,objc,objcpp,html set commentstring=//%s
au Filetype expect set commentstring=#\ %s

" Matchit (bundled with vim)
:runtime macros/matchit.vim

" a.vim
nmap <silent> <leader>A :A<CR>
let g:alternateExtensions_M = "h" " Objective-c
let g:alternateDefaultMappings = 0

" ToggleList
let g:toggle_list_no_mappings=1
nmap <silent> <tab>q :call ToggleQuickfixList()<CR>
nmap <silent> <tab>l :call ToggleLocationList()<CR>
nmap <silent> <tab>p :pclose<CR>

" YouCompleteMe (YCM)
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <silent> <buffer> <c-]> :YcmCompleter GoTo<CR>
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <silent> <buffer> <Leader>jr :YcmCompleter GoToReferences<CR>
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <silent> <buffer> <Leader>jt :YcmCompleter GetType<CR>
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <silent> <buffer> <Leader>j? :YcmCompleter GetDoc<CR>
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <buffer> <Leader>j~ :YcmCompleter RefactorRename <C-r><C-w>
au Filetype python,c,cpp,objc,objcpp,javascript nnoremap <silent> <buffer> <F5> :YcmForceCompileAndDiagnostics<CR>
let g:ycm_always_populate_location_list = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>', '<C-k>']
let g:ycm_filetype_specific_completion_to_disable = { 'java': 1, 'objc': 1, 'cpp': 1 }

" SplitJoin
let g:splitjoin_trailing_comma = 1

" Dash
nmap <silent> <leader>d <Plug>DashSearch

" Startify
let g:startify_change_to_dir = 0
let g:startify_enable_unsafe = 1
let g:startify_list_order = ['files', 'dir']

" Plugin 'pangloss/vim-javascript'  " JS highlighting/indentation.
let g:javascript_plugin_flow = 1  " Flow highlighting.

" Plugin 'mxw/vim-jsx'  " JSX highlighting/indentation.
let g:jsx_ext_required = 0  " enable for .js files.

" Plugin 'elzr/vim-json'  " JSON highlight/indentation.
let g:vim_json_syntax_conceal = 0

" au Filetype javascript nnoremap <silent> <buffer> <leader>jd :FlowJumpToDef<CR>
" au Filetype javascript nnoremap <silent> <buffer> <leader>jt :FlowType<CR>

" CamelCaseMotion
call camelcasemotion#CreateMotionMappings(',')

" Neomake
" let g:neomake_javascript_enabled_makers = ['eslint']
" let g:neomake_jsx_enabled_makers = ['eslint']
" let g:neomake_javascript_eslint_exe = './node_modules/.bin/eslint'
" let g:neomake_jsx_eslint_exe = './node_modules/.bin/eslint'
" " let g:neomake_logfile = '/tmp/neomake.log'
" augroup Neomake
"   autocmd!
"   autocmd BufWritePost,BufReadPost * if &ft =~ 'javascript' | :Neomake | endif
" augroup END

" " ESLint
" function! ESLintFix()
"   execute "!" g:neomake_javascript_eslint_exe "--fix %"
" endfunction
" command! ESLintFix call ESLintFix()

"=====[ Functions ]===========================================================

" Like bufdo but restore the current buffer.
" http://vim.wikia.com/wiki/Run_a_command_in_multiple_buffers#Restoring_position
function! BufDo(command)
  let currBuff=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . currBuff
endfunction
command! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Line splitting.
nnoremap <silent> K a<CR><ESC>k$
nmap <silent> <CR> :call Enter()<CR>
function! Enter()
  if (&modifiable)
    execute "normal! mxi\<CR>\<Esc>`x"
  else
    execute "normal! \<CR>"
  endif
endfunction

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()

function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction
command! -range=% Duplicates <line1>,<line2>call HighlightRepeats()

silent! source ~/.vimrc-osx-post
