" vim: set sw=2 ts=2 sts=2 et tw=100 foldmarker={{,}} foldlevel=0 foldmethod=marker :

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Install plugins! {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Git wrapper
Plug 'tpope/vim-fugitive'

" Wombat theme
Plug 'vim-scripts/Wombat'
Plug 'vim-scripts/wombat256.vim'

" Fzf fuzzy file matcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" File browser
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" Syntax checker
Plug 'scrooloose/syntastic'

" Golang plugin
Plug 'fatih/vim-go'

" Autocomplete
function! BuildYCM(info)
  " Post-install hook for YCM
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if !empty($NO_INSTALL_YCM) | return | endif
  if executable("cmake") && (a:info.status == 'installed' || a:info.force)
    let opts = ''
    if executable("gocode")
      let opts .= ' --gocode-completer'
    endif
    " Only attempt to install if cmake is available, since YCM needs it to
    " compile dependencies
    execute '!./install.py' . opts
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Snippets (also YCM errors if UltiSnips is not installed if VIM version is
" <7.4.107... https://github.com/Valloric/YouCompleteMe/issues/2335)
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'             " The snippet engine
Plug 'honza/vim-snippets'         " The actual snippets

" Add plugins to &runtimepath
call plug#end()
" }}

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
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
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

set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Timeout for partial key sequence matching
set ttimeout
set ttimeoutlen=100

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
" xterm2 works well with iterm
" Not supported by neovim (and probably not needed)
if &term != 'nvim'
  set ttymouse=xterm2
endif

" }}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

try
    if &term == 'nvim' || &term == 'xterm-256color' || &term == 'screen-256color'
        colorscheme wombat256mod
        set background=light
    else
        colorscheme wombat
        set background=dark
    endif
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
" Setting up the directories {
set backup                  " Backups are nice ...
if has('persistent_undo')
  set undofile                " So is persistent undo ...
  set undolevels=1000         " Maximum number of changes that can be undone
  set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
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

filetype indent on

" Linebreak on 500 characters
set linebreak
set textwidth=100

" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces

set autoindent
set smartindent
" Enable soft wrap
set nowrap

" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,css,git,html,java,javascript,json,markdown,python,sh,zsh autocmd BufWritePre <buffer> call StripTrailingWhitespace()

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

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

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
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

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
" => GUI Settings {{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set extra options when running in GUI mode
if has("gui_running")
  set guitablabel=%M\ %t
  set guioptions-=T           " Remove the toolbar
  set guioptions-=e           " Use terminal tabs in favor of GUI tabs
  " Make GVIM bigger on startup
  set lines=40 columns=84
  if !exists("g:spf13_no_big_font")
      if LINUX() && has("gui_running")
          set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
      elseif OSX() && has("gui_running")
          set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
      elseif WINDOWS() && has("gui_running")
          set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
      endif
  endif
else
  if &term == 'xterm' || &term == 'screen'
      set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
  endif
endif

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
" Search lines in open buffers
map <leader>fl :Lines<Space>
" Search commits
map <leader>fc :Commits
" Search with Codesearch (https://github.com/google/codesearch)
map <leader>cs :CSearch<Space>
map <leader>ch :CSearchCwd<Space>
" Trigger an index
map :CIndex :!cindex

" Implementation of fzf code search command {{

	" The options below do a few things:
  " 1. Sets delimiter for each searched line to : and prioritizes text match (3..) for narrowing
  "    results.
  " 2. Enables Ctrl-X (split), Ctrl-V (vsplit), Ctrl-T(tabedit)
  " 3. Enables multiselect with <Tab> and deselect with <Shift tab>
  " 4. Ctrl-A to select all, Ctrl-D to deselect all
  " 5. Creates a Cs> prompt at the bottom
  " 6. Ensures fzf opens in full screen (<bang>0)
  if executable('csearch_rel')
    " Use my custom csearch wrapper that changes paths to relative paths if available.
    let csearch = 'csearch_rel'
  else
    let csearch = 'csearch'
  endif
  " Search everything in the index
	command! -bang -nargs=* CSearch call fzf#run(fzf#wrap({
		\ 'source': csearch . ' -n -i <q-args>',
		\ 'sink*': function('<sid>csearch_handler'),
		\ 'options': '--delimiter : --nth 3..,.. --prompt "Cs> " '.
		\            '--multi --bind ctrl-a:select-all,alt-n:deselect-all '
		\ }), <bang>0)

  " Search only files under cwd
	command! -bang -nargs=* CSearchCwd call fzf#run(fzf#wrap({
		\ 'source': csearch . ' -f ' . getcwd() . ' -n -i <q-args>',
		\ 'sink*': function('<sid>csearch_handler'),
		\ 'options': ' --delimiter : --nth 3..,.. '.
    \            ' --prompt "Cs> "'.shellescape(pathshorten(getcwd())).'/'.
		\            ' --multi --bind ctrl-a:select-all,alt-n:deselect-all '
		\ }), <bang>0)

	function! s:csearch_handler(lines)
		if len(a:lines) < 1
			return
		endif

    " Input is a list of lines selected from csearch output, of format "filename:line:linetext"
		let list = map(a:lines, 's:cs_to_qf(v:val)')
		let first = list[0]

		" Do not do anything if the file picked is the current file
		if fnamemodify(first.filename, ':p') ==# expand('%:p')
			return
		endif

		try
			" Open the picked file for editing
			execute 'edit' s:escape(first.filename)
			" Go to the matched line
			execute first.lnum
		catch
		endtry

    " Put all of the files in the quickfix list if there is more than 1 selected file
    if len(list) > 1
      call setqflist(list)
      copen
      wincmd p
    endif
	endfunction

	function! s:cs_to_qf(line)
		" Convert code search result to quick fix list (:help setqflist) entries
		let parts = split(a:line, ':')
		return {
		\  'filename': parts[0],
		\  'lnum': parts[1],
    \  'col': 0,
		\  'text': join(parts[2:], ':')
		\ }
	endfunction

	function! s:escape(path)
		" Escape special characters in the path for use by the edit command
		return escape(a:path, ' $%#''"\')
	endfunction
"   }}
" }}

" NERDTree {{
if isdirectory(expand("~/.vim/plugged/nerdtree"))
  map <C-e> <plug>NERDTreeTabsToggle<CR>
  map <leader>e :NERDTreeFind<CR>
  nmap <leader>nt :NERDTreeFind<CR>

  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
  let NERDTreeChDirMode=2
  let NERDTreeQuitOnOpen=0
  let NERDTreeMouseMode=2
  let NERDTreeShowHidden=1
  let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }}

" YouCompleteMe, UltiSnips, and SuperTab {{
let g:ycm_autoclose_preview_window_after_completion = 1

" Bind YCM to <C-n>
let g:ycm_key_list_select_completion = ['<C-n>', '<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<C-k>', '<Up>']

" Let SuperTab translate <tab> to <C-n> for completions, otherwise goes to UltiSnips
let g:SuperTabDefaultCompletionType = '<C-n>'

" Nice UltiSnips bindings
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}

" Syntastic {{
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_java_checkers = []
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 3
" Make sure syntastic does not conflict with fatih/vim-go
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
" }}

" Vim-Go {{
" Use quickfix instead of loclist to not conflict with synastic
let g:go_list_type = "quickfix"
" Enable lots of syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" Use goimports to format code
let g:go_fmt_command = "goimports"
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

" Strip whitespace
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
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

