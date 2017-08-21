" vim: set sw=2 ts=2 sts=2 et tw=80 foldmarker={,} foldlevel=0 foldmethod=marker spell:

" NOTE {
" THE BELOW ASSUMES THAT YOU HAVE INSTALLED " vim-plug https://github.com/junegunn/vim-plug
"   Tarun Ramakrishna Elankath's vimrc file. Been using VIM for 8 years now. 
"   Re-created from scratch on Aug 20, 2011
"   https://github.com/lenkite/dotfiles
" }

" PLUGINS PRE-CONFIGURATION Variables  {
let g:cargo_makeprg_params='build'
" }


call plug#begin('~/.vim/plugged')

" TPope plugins: Bracket mappings, surround, comment, repeat {  
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
" }

" Windows {
Plug 'drn/zoomwin-vim'
" }

" async library for vim plugins such as unite
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" COMPLETION and SNIPPETS {
"Plug 'SirVer/ultisnips'
Plug 'Shougo/neocomplete.vim'
"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'
"Plug 'ervandew/supertab'
"Plug 'honza/vim-snippets'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'SirVer/ultisnips'
" }


" Navigation: Fuzzy Find, Nerd Tree, Tags , etc {
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'
"
" "}


" Syntax/Linting  {
Plug 'scrooloose/syntastic'
" }

" Language Plugins {
" Rust Lang plugin
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" D Lang plugins
Plug 'idanarye/vim-dutyl'
Plug 'gabrielelana/vim-markdown'
" "}


"SEARCH {
Plug 'mhinz/vim-grepper'
"}

" Motion and Text Objects {
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
"}

Plug 'haya14busa/incsearch.vim'

Plug 'tmhedberg/matchit'
Plug 'flazz/vim-colorschemes'

" Table Alignment and Editing Plugins {
Plug 'junegunn/vim-easy-align'
" }

" Ascii Doc Plugin and Deps {
Plug 'dahu/vimple'
Plug 'dahu/Asif'
Plug 'Raimondi/VimRegStyle' "library plugin
Plug 'vim-scripts/SyntaxRange'
Plug 'dahu/vim-asciidoc'
Plug 'terryma/vim-expand-region'
"}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


Plug 'airblade/vim-rooter'


" Add plugins to &runtimepath
call plug#end()


exec 'source'. g:vimCfgDir . '/basic-keymap.vim'
let s:cfgs=split(globpath(g:vimCfgDir, '*cfg.vim'), '\n')
for s:cfg in s:cfgs
	exec ":source " . s:cfg
endfor









