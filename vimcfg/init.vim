" vim: set sw=2 ts=2 sts=2 et tw=80 foldmarker={,} foldlevel=0 foldmethod=marker spell:

" NOTE {
"   Tarun Ramakrishna Elankath's vimrc file. Been using VIM for 12 years now. 
"   Re-created from scratch on Aug 20, 2011
"   Re-created from scratch again on Aug 6, 2016, taking the best parts from YADR
"   Extensively modified in period Aug, 2017
"   Decision to ditch vim and use only neovim in 5th May, 2018
"   https://github.com/lenkite/dotfiles
" }

" { * REMOVED: Directs neovim to use vim config. 
" solely use neovim
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
" }

" { * Prelude: Encoding, Modeline Settings
"https://stackoverflow.com/questions/18321538/vim-error-e474-invalid-argument-listchars-tab-trail
scriptencoding utf-8
set encoding=utf-8
set modeline
set modelines=1
let g:impact_transbg=1
" }

"{ * Basics: Undo, Swap, Backup, Indent, Syntax, Spelling, Screen, Folds
set autowrite                  " Writes contents of file on next rewind last first make etc
set smartcase       " ignores case (default) unless we type a capital
set completeopt=longest,menuone

" { ** Persistent Undo 
set undofile
set undolevels=2000         " How many undos
set undoreload=15000        " number of lines to save for undo
"  }

"{ ** Turn Off Swap Files And Backups 
set noswapfile
set nobackup
set nowb
"}
"
" { ** Indentation 
set autoindent
set smartindent
set smarttab
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0 "Make files need a Tab!
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
"}

" ** { Syntax and Spelling
syntax on
filetype plugin on
filetype indent on
set spelllang=en
set spellfile=~/dotfiles/spell/en.utf-8.add
" }

" { ** Screen Related
set visualbell noerrorbells
set lazyredraw " redraw only when we need to
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set number                     " Line numbers are good
set relativenumber             " Relative line numbers are better but cause SLOW SCROLLING :(
set hidden
set wmh=0                      " Set winminheight to 0 so that
                               " maximizing a window collapses all other windows
set scrolloff=6                "Start scrolling when we're 8 lines away from margins
set sidescrolloff=8
set sidescroll=1
"}

"{ ** Folds 
set foldnestmax=2
set foldlevel=0
" }

"}

" { * Matchit and Parenthesis
set matchtime=1 "time in tenths of a second to show the matching parenthesis
set showmatch "The vim implementation of matching parenthesis sucks
let loaded_matchparen = 1 "Parenthesis highlight is distracting like hell!
"}

" { * Terminal and Remote Config (for nvim)
let $VISUAL = 'nvr -cc split --remote-wait'
set shell=/bin/zsh
let $LC_ALL='C'
" }

" { * Autoreload vimrc
autocmd! bufwritepost vimrc source %
" }

"{ * Basic Key Mappings
" Allow quit via single keypress (Q)
nmap ZQ :qa!<CR>
"Save files since Cmd-S and Ctrl-S don't work well on Terminals (aaargh!)
noremap <Leader>s :update<CR>
inoremap <Leader>s <Esc>:update<CR>

"Clear highlight on double escape
nnoremap <esc><esc> :noh<return>

" From https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yyj).
noremap Y y$

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
inoremap <C-e> <C-o>$

"Window management Commands
"https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"https://www.reddit.com/r/neovim/comments/6mkvo3/builtin_terminals_or_tmux/
"
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Lovely! Got from some reddit post in the VIM forum to map backspace to last used file.
nnoremap  <BS> <C-^>

" From reddit
" https://www.reddit.com/r/vim/comments/6pw5ui/what_is_the_most_diffucult_vim_command_to_enter/
" Just do a visual selection and K J will move it up & down and it'll also
" reindent the code correctly.
" Move visual block. [Tarun: This is amazing and I can't understand it, Freaky]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Easy edit of files in same directory of current buffer
" http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
" http://vimcasts.org/episodes/the-edit-command/
" Choose to use <Leader>E since <Leader>e is used by FZF :Buffers
" cabbr <expr> %% expand('%:p:h')
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>Ew :e %%
map <leader>Es :sp %%
map <leader>Ev :vsp %%
map <leader>Et :tabe %%

"}

"{ * Plugin List (Assumes you have vim-plug installed!
"
call plug#begin('~/.local/share/nvim/plugged')

" ** Plugins: Tpope: Bracket mappings, surround, commentary, repeat {  
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-fireplace' "nREPL
"}

" ** Plugins: Buffer and Window {
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify' "Fancy start screen
"}

" ** Plugins: Navigation: Fuzzy Find, Vimfiler, Tags , etc {

"Because vim-go uses this for GoDecls
Plug 'ctrlpvim/ctrlp.vim' 
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'justinmk/vim-dirvish'
Plug 'scrooloose/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'travisjeffery/vim-gotosymbol'
"}

" ** Plugins: Motion, Text Objects, Regions {
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
"}

" ** Plugins: Completion And Snippets {
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'

Plug 'mattn/emmet-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"}

" ** Plugins: Language, Syntax, Linting {
Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'w0rp/ale'
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'ap/vim-css-color' "highlights CSS colors
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'shime/vim-livedown'
Plug 'vim-scripts/SyntaxRange'
"}

" ** Plugins: Search {
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
Plug 'haya14busa/incsearch.vim'
Plug 'adelarsq/vim-matchit'
Plug 'rhysd/devdocs.vim' "for devdocs.io
Plug 'keith/investigate.vim' "opens dash on macOS
Plug 'yssl/QFEnter' "Open a Quickfix item in a window you choose
"}

" { ** Plugins: Misc: light status line and router. airline/powerline suck
" From https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
Plug 'bluz71/vim-moonfly-statusline'
Plug 'airblade/vim-rooter'
"}

" ** Table Alignment and Editing Plugins {
Plug 'junegunn/vim-easy-align'
"}

" ** Plugins: Color Schemes {
Plug 'chriskempson/base16-vim'
Plug 'rafi/awesome-vim-colorschemes'
"}

call plug#end() "Intialize Plugin system
"}

" { * Configure: FZF NERDTree,  Dirvish, Tagbar, Rooter

function! ConfigureFzf()
  nmap <Leader>e :Buffers<CR>
  map <C-p> :FZF<CR>
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

endfunction
autocmd VimEnter * if exists(":FZF") | call ConfigureFzf() | endif

function! ConfigureNerdTree()
  " f for filess
  nnoremap <Leader>ff :NERDTreeToggle<CR>
  nnoremap <Leader>fF :NERDTreeFind<CR>
  nnoremap <Leader>fb :NERDTreeFromBookmark<CR>
  nnoremap <Leader>fc :NERDTreeCWD<CR>

  " From FAQ: How can I open NERDTree automatically when vim starts up on
  " opening a directory? (How can I open NERDTree automatically when vim starts
  " up on opening a directory?)
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

  " From FAQ: Close vim if only window left open is NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " From https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
  " Though I have made my own keybindings
  let NERDTreeQuitOnOpen = 1

  " Automatically delete the buffer of the file you just deleted with NerdTree:
  let NERDTreeAutoDeleteBuffer = 1

  "You’re going to be looking at your NerdTree a lot. You might as well make
  "sure it looks nice and disable that old “Press ? for help”.
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1
  let NERDTreeShowBookmarks = 1
endfunction
autocmd VimEnter * if exists(":NERDTree") | call ConfigureNerdTree() | endif

function! ConfigureDirvish()
  nnoremap <Leader>fd :Dirvish<CR>
endfunction

autocmd VimEnter * if exists(":Dirvish") | call ConfigureDirvish() | endif
" autocmd VimEnter * if exists(":Dirvish") | exe "nnoremap <Leader>fd :Dirvish\<CR>" | endif

function! ConfigureTagbar()
  nmap <Leader>o :Tagbar<CR>
endfunction
autocmd VimEnter * if exists(":Tagbar") | call ConfigureTagbar() | endif

" To stop vim-rooter echoing the project directory:
let g:rooter_silent_chdir = 1
" To change directory for the current window only 
let g:rooter_use_lcd = 1



" }

" { * Configure: Search Plugin 
"From https://github.com/haya14busa/incsearch.vim
function! ConfigureIncSeaarch()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
endfunction
autocmd VimEnter * if exists(":IncSearchMap") | call ConfigureIncSeaarch() | endif

function! ConfigureVimGrepper()
  " This defines an |operator| "gs" that takes any |{motion}| and uses that
  " selection to populate the search prompt. The query is quoted automatically.
  " Useful examples are gsW, gsiw, or gsi.
  nmap gs  <plug>(GrepperOperator)
  xmap gs  <plug>(GrepperOperator)
endfunction
autocmd VimEnter * if exists(":Grepper") | call ConfigureVimGrepper() | endif

function! ConfigureInvestigate()
  let g:investigate_use_dash=1 "opens documentation using gK in dash on macos
  let g:investigate_syntax_for_godoc="go"
endfunction
call ConfigureInvestigate()


" }

" { * Configure: Asciidoc 
function! UpdateAndMake()
  :update
  :silent! make
  :redraw!
endfunction
function! ConfigureAsciidoc()
  au FileType asciidoc silent compiler! asciidoctor
  au FileType asciidoc noremap <leader>b :make<CR>
  au FileType asciidoc noremap <Leader>s :call UpdateAndMake()<CR>
endfunction
autocmd FileType asciidoc call ConfigureAsciidoc()
" }

" { * Configure: Rust Lang 
"Set the compiler as cargo for rust files
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
"}

" { * Configure: Go Lang 
" golang config taken from example mappings in https://github.com/fatih/vim-go
"
function! ConfigureVimGo()
  au FileType go nmap <Leader>x <Plug>(go-run)
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <leader>t <Plug>(go-test)
  au FileType go nmap <leader>c <Plug>(go-coverage)

  au FileType go nmap <leader>ds <Plug>(go-def-split)
  au FileType go nmap <leader>dv <Plug>(go-def-vertical)
  au FileType go nmap <leader>dt <Plug>(go-def-tab)

  au FileType go nmap <leader>gd <Plug>(go-doc)
  au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
  au FileType go nmap <leader>gb <Plug>(go-doc-browser)

  au FileType go nmap <leader>i <Plug>(go-info)
  au FileType go nmap <leader>r <Plug>(go-rename)
  au FileType go set path+=~/src,~/src/go/src




endfunction
"See https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876
let g:go_fmt_command = "goimports"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

"Deoplete Configuration
let g:deoplete#enable_at_startup = 1
let g:deoplete#num_processes = 1

" " Error and warning signs.
" let g:ale_sign_error = '⤫'
" let g:ale_sign_warning = '⚠'
"let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
autocmd FileType go if exists(":GoBuild") | call ConfigureVimGo() | endif

" }

" { * Configure: Typescript Lang 
" See:  https://github.com/Quramy/tsuquyomi
"
function! ConfigureVimTypescript()
  au FileType typescript nmap <leader>i <Plug>(TsuquyomiSignatureHelp)
  au FileType typescript imap <leader>i <C-o><Plug>(TsuquyomiSignatureHelp)
endfunction
autocmd FileType typescript if exists(":TsuquyomiStartServer") | call ConfigureVimTypescript() | endif

" }

" { * Configure: Sneak 
"replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
"replace 't' with 1-char Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
" }

" * Configure: EasyAlign {
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"}

" * Configure: Emmet {
"autocmd FileType html imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
"autocmd FileType html imap  <tab> emmet#expandAbbrIntelligent("\<tab>")
"autocmd FileType css imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_leader_key = '<C-y>'
" }

"base16-vim
try 
  if !has('mac') 
    if filereadable(expand("~/.vimrc_background"))
      let base16colorspace=256
      source ~/.vimrc_background
    endif
  else 
    colorscheme gruvbox
    set background=dark
  endif
catch
endtry

