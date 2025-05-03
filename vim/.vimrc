" vim: set sw=2 ts=2 sts=2 et tw=100 foldmarker={{,}} foldlevel=0 foldmethod=marker :

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Identify Platform {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction

"}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Install plugins! {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Git wrapper
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Abolish - case/abbrev preserving substitution, snake/camel coersion
Plug 'tpope/vim-abolish'

" In-file navigation
Plug 'easymotion/vim-easymotion'
" Multiple cursors with <C-n>
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Automatic closing of quotes, parenthesis, braces
Plug 'Raimondi/delimitMate'
" Changing braces with cs
Plug 'tpope/vim-surround'

" Edit in quickfix list
Plug 'Olical/vim-enmasse'

" Wombat theme
Plug 'vim-scripts/Wombat'
Plug 'vim-scripts/wombat256.vim'

" Whitespace highlighting
Plug 'ntpeters/vim-better-whitespace'

" Fzf fuzzy file matcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" File browser
Plug 'scrooloose/nerdtree'

" Tagbar for viewing file ctags
Plug 'majutsushi/tagbar'

" Sessions
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc' " Dependency of vim-session

" Dash integration
if OSX()
  Plug 'rizzatti/dash.vim'
endif

" Syntax checker
Plug 'scrooloose/syntastic'

" Golang plugin
Plug 'fatih/vim-go'

" Terraform syntax
Plug 'hashivim/vim-terraform'

if has("nvim")
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/nvim-cmp'
endif

" Add plugins to &runtimepath
call plug#end()
" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make vim better, in general
set nocompatible

" Sets how many lines of history VIM has to remember
set history=1000

" Enable filetype plugins
filetype plugin on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Point neovim to global python installation so that the Python neovim
" (pynvim) package doesn't have to get installed into every virtualenv
if OSX()
  let g:python3_host_prog = '/opt/homebrew/bin/python3'
endif
" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class
" Ignore version control and system files
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    " set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store " Seems like setting wildignore interferes with fugitive :Gdiff command when doing 3-way merge.
endif

" Always show current position
set ruler

" Display the current mode
set showmode

" Highlight the current line
set cursorline

" Always show line number
set number

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=b,<,>,h,l

" When searching try to be smart about cases
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Makes search act like incremental search in modern browsers
set incsearch

" Disable spellcheck. More obtrusive than I'd like
set nospell

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Timeout for partial key sequence matching
set ttimeout
set ttimeoutlen=100

" set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

if !has("nvim")
  " Set this to the name of your terminal that supports mouse codes.
  " Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
  " xterm2 works well with iterm
  " Not supported by neovim (and probably not needed)
  set ttymouse=xterm2
endif

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

try
  colorscheme wombat256mod
  set background=dark
catch
endtry

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" show right margin at 101 characters
set colorcolumn=101

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autowrite " Save on make, or go build...
" Setting up the directories {
set backup                  " Backups are nice ...
if has('persistent_undo')
  set undofile                " So is persistent undo ...
  set undolevels=1000         " Maximum number of changes that can be undone
  set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
" Backups break crontab editing
autocmd filetype crontab setlocal nobackup nowritebackup
" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab, space, wrap and indent related {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
" Let backspace delete indent
set softtabstop=2
" Show tabs as arrows
set list
set listchars=tab:>-
" Disable showing tabs for Go files since tabs are the standard
autocmd FileType go autocmd BufEnter <buffer> set nolist

" Strip whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

filetype indent on

" Linebreak on 100 characters
set linebreak
set textwidth=100

" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces

set autoindent
set cindent
" Enable soft wrap
set nowrap
" }}

""""""""""""""""""""""""""""""
" => Visual mode related {{
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable highlight when <leader>/ is pressed
map <silent> <leader>/ :noh<cr>

" Visual navigation with j/k
noremap j gj
noremap k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
if has("nvim")
  tnoremap <C-w>h <C-\><C-n><C-w>h
  tnoremap <C-w>j <C-\><C-n><C-w>j
  tnoremap <C-w>k <C-\><C-n><C-w>k
  tnoremap <C-w>l <C-\><C-n><C-w>l
endif

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Opens a split terminal
command Sterm split term://$SHELL
command Vterm vsplit term://$SHELL
command Tterm tabnew term://$SHELL

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
" Switch CWD to the GITROOT of the open buffer
map <leader>gcd :execute 'cd' fugitive#repo().tree()<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }}

""""""""""""""""""""""""""""""
" => Code folding {{
""""""""""""""""""""""""""""""
set foldenable                  " Auto fold code
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" }}

""""""""""""""""""""""""""""""
" => Status line {{
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ CWD:%r%{pathshorten(fnamemodify(getcwd(),\":~\"))}%h\ \ L:%l,C:%c

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Replace word under cursor
nmap <leader>s :%s/\<<C-r><C-w>\>//<Left>

nmap Y y$

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF {
" Search through files within git repo
map <C-p> :GFiles<cr>
map <leader>fg :GFiles<cr>
" Search through modified git files
map <leader>fo :GFiles?<cr>
" Search through all files under <cwd>
map <C-t> :Files<cr>
map <leader>ff :Files<cr>
" Search through open buffers
map <leader>fb :Buffers<cr>
" Start an Ag prompt to get a term, and then filter
map <leader>ag :Ag<Space>
" Start an Rg prompt to get a term, and then filter
map <leader>ag :Rg<Space>
" Search lines in open buffers
map <leader>fl :Lines<cr>
" Search commits
map <leader>fc :Commits<cr>
" Search with Codesearch (https://github.com/google/codesearch)
map <leader>cs :CSearch<Space>
map <leader>ch :CSearchCwd<Space>
" Trigger an index
map :CIndex :!cindex

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" Likewise, GFiles command with preview window
command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
" }}

" NERDTree {{
if isdirectory(expand("~/.vim/plugged/nerdtree"))
  map <C-e> :NERDTreeToggle<CR>
  map <leader>e :NERDTreeFind<CR>

  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
  let NERDTreeChDirMode=1
  let NERDTreeQuitOnOpen=0
  let NERDTreeMouseMode=2
  let NERDTreeShowHidden=1
  let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }}

" Syntastic {{
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_java_checkers = []
let g:syntastic_javascript_checkers = ['eslint']
" Make the loc list auto-show when there are errors, hide when there are not
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3
" Make sure syntastic does not conflict with fatih/vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" Add to the status line? Not sure if I like the effect.
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
" }}

" Vim-Go {{
" Enable lots of syntax highlighting
"let g:go_highlight_functions = 1
"let g:go_highlight_methods = 1
"let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
"let g:go_highlight_build_constraints = 1
" Use goimports to format code
let g:go_fmt_command = "goimports"
let g:go_fmt_options = {
  \ 'gofmt': '-s',
  \ }
" Show type information for word under cursor
" let g:go_auto_type_info = 1
let g:go_info_mode = 'guru'
" let g:go_update_time = 2000

let g:go_term_enabled = 0
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = ['vet', 'vetshadow', 'golint', 'gotype']

" Override traditional commands for alternating (test) files
augroup go
  autocmd!
  autocmd Filetype go
    \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    \| command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Mappings for building, running, and testing Go code
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" Mappings for viewing info about what's under the cursor
autocmd FileType go nmap <leader>i  <Plug>(go-info)
autocmd FileType go nmap <leader>vI  <Plug>(go-implements)
autocmd FileType go nmap <leader>vd  <Plug>(go-doc)
autocmd FileType go nmap <leader>vD  <Plug>(go-doc-browser)
autocmd FileType go nmap <leader>vc  <Plug>(go-callers)
autocmd FileType go nmap <leader>vC  <Plug>(go-callees)
autocmd FileType go nmap <leader>vf  <Plug>(go-freevars)
autocmd FileType go nmap <leader>vp  <Plug>(go-channelpeers)

" Mappings for jumping to relevant context for what's under the cursor
autocmd FileType go nmap gD  <Plug>(go-def-vertical)

" Mapping for navigating symbols in the file and package
autocmd FileType go nmap <leader>d :GoDecls<CR>
autocmd FileType go nmap <leader>D :GoDeclsDir<CR>
" }}

" Tag Bar {{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
" }}

" Dash {{
map <silent> <leader><leader>d <Plug>DashSearch
map <silent> <leader><leader>gd <Plug>DashGlobalSearch
" }}

" Sessions {{
let g:session_autoload = 'no'
let g:session_autosave = 'yes'
" }}

" delimitMate {{
let delimitMate_expand_cr = 1
" }}

" Javascript specific {{
  " Syntax highlighting
  let g:javascript_plugin_jsdoc = 1
  " Prettier
  " let g:prettier#autoformat = 0
  " autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql PrettierAsync
" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Initialize directories
function! InitializeDirectories()
  let parent = $HOME
  let prefix = 'vim'
  let dir_list = {
              \ 'backup': 'backupdir',
              \ 'views': 'viewdir',
              \ 'swap': 'directory' }

  if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
  endif

  let common_dir = parent . '/.' . prefix
  for [dirname, settingname] in items(dir_list)
      let directory = common_dir . dirname . '/'
      if exists("*mkdir")
          if !isdirectory(directory)
              call mkdir(directory)
          endif
      endif
      if !isdirectory(directory)
          echo "Warning: Unable to create backup directory: " . directory
          echo "Try: mkdir -p " . directory
      else
          let directory = substitute(directory, " ", "\\\\ ", "g")
          exec "set " . settingname . "=" . directory
      endif
  endfor
endfunction
call InitializeDirectories()

" }}

" Use local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

