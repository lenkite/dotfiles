" vim: set sw=2 ts=2 sts=2 et tw=80 foldmarker={,} foldlevel=0 foldmethod=marker spell:

" NEO VIM init config file
" NOTE {
"   Tarun Ramakrishna Elankath's vimrc file. Been using VIM for 12 years now. 
"   Re-created from scratch on Aug 20, 2011
"   Re-created from scratch again on Aug 6, 2016, taking the best parts from YADR
"   Extensively modified in period Aug, 2017
"   Decision to ditch vim and use only neovim in 5th May, 2018
"   https://github.com/lenkite/dotfiles
" }

" { * Directs neovim to use vim config. 
"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
" }

" {* Only very basic minimal settings are present in vimrc
source ~/.vimrc
" }


" { * Terminal Config (for nvim)
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
  set shell=/bin/zsh
  let $LC_ALL='C'
  "Hit double escape to get out of terminal mode. Umm no this messes up fzf
  "escape
	"tnoremap <Esc><Esc> <C-\><C-n> 
endif
" }

" { * Autoreload init.vim
autocmd! bufwritepost init.vim source %
" }

"{ * Plugin List (Assumes you have vim-plug installed!
call plug#begin('~/.vim/plugged')

" ** Plugins: Tpope: Bracket mappings, surround, commentary, repeat {  
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-fireplace' "nREPL
Plug 'tpope/vim-vinegar' "on recommendation from https://martin-ueding.de/articles/cpp-with-vim/index.html
Plug 'tpope/vim-apathy'
"}

" ** Plugins: Buffer, Window, Sessions {
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify' "Fancy start screen
Plug 'christoomey/vim-tmux-navigator' "https://blog.bugsnag.com/tmux-and-vim/
" }

" ** Plugins: Completion And Snippets {
" Plug 'Shougo/neosnippet' "commented out due to problem with LanguageClient
" Plug 'Shougo/neosnippet-snippets'
" Plug 'SirVer/ultisnips'  "since LanguageClient only supports this and causes problemsiwth neosnippet
Plug 'ervandew/supertab'
" Plug 'honza/vim-snippets'
Plug 'mdempsky/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'mattn/emmet-vim'
if has('nvim')
  Plug 'autozimu/LanguageClient-neovim', {
			\ 'branch': 'next',
			\ 'do': 'bash install.sh',
			\ }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-go', { 'do': 'make'}
  Plug 'zchee/deoplete-jedi'
  Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'roxma/nvim-yarp'
  " Plug 'ncm2/ncm2'
  " Plug 'ncm2/ncm2-bufword'
  " Plug 'ncm2/ncm2-path'
  " Plug 'ncm2/ncm2-jedi'
  " Plug 'ncm2/ncm2-go'
  " Plug 'mhartington/nvim-typescript'
endif
"}

" ** Plugins: Navigation: Fuzzy Find, Vimfiler, Tags , etc {

"Because vim-go uses this for GoDecls
Plug 'ctrlpvim/ctrlp.vim' 
if has('win32')
  Plug 'junegunn/fzf', {'dir': '~/.fzf'}
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'justinmk/vim-dirvish'
Plug 'scrooloose/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'travisjeffery/vim-gotosymbol'
"
" "}

" ** Plugins: Motion, Text Objects, Regions {
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
"}

" ** Plugins: Language, Syntax, Linting {
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'w0rp/ale'
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'ap/vim-css-color' "highlights CSS colors
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'shime/vim-livedown'
Plug 'vim-scripts/SyntaxRange'
Plug 'python-mode/python-mode', { 'branch': 'develop' }

"Plugins for Clojure
Plug 'guns/vim-clojure-static' "Syntax highlighting for clojure
Plug 'guns/vim-clojure-highlight' "Extended highlighting.
Plug 'guns/vim-sexp' 
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-salve'
Plug 'markwoodhall/vim-figwheel'
Plug 'gberenfield/cljfold.vim'
"Plug 'bhurlow/vim-parinfer'
if executable("cargo")
  Plug 'eraserhd/parinfer-rust', {'do':
        \  'cargo build --release'}
endif
Plug 'luochen1990/rainbow'


"}

" ** Plugins: Search {
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
Plug 'haya14busa/incsearch.vim'
Plug 'tmhedberg/matchit'
Plug 'rhysd/devdocs.vim' "for devdocs.io
Plug 'keith/investigate.vim' "opens dash on macOS
Plug 'KabbAmine/zeavim.vim' "for opening zeal on windows
Plug 'yssl/QFEnter'
"}

" ** Plugins: Color Schemes {
"Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'rafi/awesome-vim-colorschemes'
"https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
" Plug 'rakr/vim-one'
" Plug 'morhetz/gruvbox'
" Plug 'joshdick/onedark.vim'
" Plug 'dracula/vim'
"}

" ** Table Alignment and Editing Plugins {
Plug 'junegunn/vim-easy-align'
" }

" ** Shell,Terminal, Dispatch {
Plug 'tpope/vim-dispatch/'
if has('nvim')
  Plug 'radenling/vim-dispatch-neovim'
endif

" }

" { ** Misc Plugins: Light weight status line. airline/powerline suck
" From https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
Plug 'bluz71/vim-moonfly-statusline'
Plug 'airblade/vim-rooter'
"}

" Add plugins to &runtimepath
call plug#end()
"}

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


" From http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk





" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yyj).
noremap Y y$

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
"inoremap <C-e> <C-o>$ "Tpops vim-rsi plugin now handles this.

"Window management Commands
"https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"https://www.reddit.com/r/neovim/comments/6mkvo3/builtin_terminals_or_tmux/

if has('nvim')
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

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

" { * NEOVIM specific onfig
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait'
endif
" }

" { * Configure: fzf NERDTree,  Dirvish, Tagbar Config, Rooter

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


" { * Configure: incsearch
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
" }

" { * Configure: vim grepper
function! ConfigureVimGrepper()
  " This defines an |operator| "gs" that takes any |{motion}| and uses that
  " selection to populate the search prompt. The query is quoted automatically.
  " Useful examples are gsW, gsiw, or gsi.
  nmap gs  <plug>(GrepperOperator)
  xmap gs  <plug>(GrepperOperator)
endfunction
autocmd VimEnter * if exists(":Grepper") | call ConfigureVimGrepper() | endif
" }

" { * Configure Docu Search Plugins
function! ConfigureInvestigate()
  let g:investigate_use_dash=1 "opens documentation using gK in dash on macos
  let g:investigate_syntax_for_godoc="go"
endfunction
call ConfigureInvestigate()

function! ConfigureZeal()
  let g:zv_disable_mapping=1
  if $isWsl == "true"
    let g:zv_zeal_executable = '/mnt/c/Program Files/Zeal/zeal.exe'
    " nmap <leader>z <Plug>Zeavim
    " vmap <leader>z <Plug>ZVVisSelection
    "nmap gK <Plug>ZVOperator
    nmap <leader>gK <Plug>Zeavim
    " nmap <leader><leader>z <Plug>ZVKeyDocset
  endif
endfunction
call ConfigureZeal()
autocmd VimEnter * if exists(":Zeavim") | call ConfigureZeal() | endif

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

" { * Configure Lang Client/Server
function! ConfigureLangClient()
  set completefunc=LanguageClient#complete
  set formatexpr=LanguageClient_textDocument_rangeFormatting()
  au FileType rust nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
  au FileType rust nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  au FileType ruls nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  au FileType ruls nnoremap <silent> <leader> :r LanguageClient#textDocument_rename()<CR>
  nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
  nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
  nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction
if has('nvim')
  let g:LanguageClient_serverCommands = {
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
        \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
        \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
        \ }
  " Automatically start language servers.
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_loadSettings = 1
  let g:LanguageClient_settingsPath  = expand('~/dotfiles/cquery_settings.json')
  autocmd FileType rust,cpp,python call ConfigureLangClient()
endif
" }

" { * Configure Rust Lang
"Set the compiler as cargo for rust files
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
"}

" { * Configure Go Lang
"Taken from example mappings in https://github.com/fatih/vim-go
"
function! ConfigureVimGo()
  setlocal nospell
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

" { * Completion Configuration
 let g:deoplete#enable_at_startup = 1
 let g:deoplete#num_processes = 1
 let g:SuperTabDefaultCompletionType = "<c-n>"  "https://stackoverflow.com/questions/17104861/vim-supertab-plugin-reverses-the-direction-when-navigating-completion-menu

" from https://github.com/ncm2/ncm2
" Use <TAB> to select the popup menu:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

if has('nvim')
  " wrap existing omnifunc
  " Note that omnifunc does not run in background and may probably block the
  " editor. If you don't want to be blocked by omnifunc too often, you could
  " add 180ms delay before the omni wrapper:
  "  'on_complete': ['ncm2#on_complete#delay', 180,
  "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
  
  " au User Ncm2Plugin call ncm2#register_source({
  "       \ 'name' : 'css',
  "       \ 'priority': 9, 
  "       \ 'subscope_enable': 1,
  "       \ 'scope': ['css','scss'],
  "       \ 'mark': 'css',
  "       \ 'word_pattern': '[\w\-]+',
  "       \ 'complete_pattern': ':\s*',
  "       \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
  "       \ })
  " " enable ncm2 for all buffers
  "  autocmd BufEnter * if exists("ncm2") | call ncm2#enable_for_buffer() | endif
endif

"}


" " Error and warning signs.
" let g:ale_sign_error = '⤫'
" let g:ale_sign_warning = '⚠'
"let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
autocmd FileType go if exists(":GoBuild") | call ConfigureVimGo() | endif

" }

" { * Configure Python Mode
" https://github.com/python-mode/python-mode
"
function! ConfigurePythonMode()
  setlocal nospell
endfunction
autocmd FileType python if exists(":PymodeVersion") | call ConfigurePythonMode() | endif
let g:pymode_run_bind = '<leader>x'

" }

" { * Configure Typescript Lang 
" See:  https://github.com/Quramy/tsuquyomi
"
function! ConfigureVimTypescript()
  setlocal nospell
  autocmd FileType typescript setlocal completeopt+=menu,preview
  let g:tsuquyomi_completion_detail = 1
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

" * Configure: Clojure/Clojurescript {
"au FileType clojure :command! PiggyDear Piggieback (figwheel-sidecar.repl-api/repl-env)   
au FileType clojure noremap <C-]> <Plug>FireplaceDjump 
au FileType clojure noremap <C-T> <C-O>
au FileType clojure let g:rainbow_active = 1 
au FileType clojure set showmatch

" }
"
"{ * MISC GLOBAL Variables 
let g:skip_loading_mswin="true"  "Do not like mswin settings. Want consistent behaviour across platforms
" Use deoplete.
let g:cargo_makeprg_params='build'
"}

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


" See :h provider--python
if has('macunix')
 let g:python3_host_prog='/usr/local/bin/python3'
endif



" let g:ulti_expand_res = 0 "default value, just set once
" function! CompleteSnippet()
"   if empty(v:completed_item)
"     return
"   endif

"   call UltiSnips#ExpandSnippet()
"   if g:ulti_expand_res > 0
"     return
"   endif
  
"   let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
"   let l:comp_len = len(l:complete)

"   let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
"   let l:cur_line = getline('.')

"   let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
"   let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''

"   call setline('.', l:start . l:end)
"   call cursor('.', l:cur_col - l:comp_len + 2)

"   call UltiSnips#Anon(l:complete)
" endfunction
" autocmd CompleteDone * call CompleteSnippet()

" imap <silent><expr> <tab> pumvisible() ? "\<c-y>" : "\<tab>"

" let g:UltiSnipsExpandTrigger="<NUL>"
" let g:UltiSnipsListSnippets="<NUL>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

