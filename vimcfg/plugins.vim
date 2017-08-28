" vim: set sw=2 ts=2 sts=2 et tw=80 foldmarker={,} foldlevel=0 foldmethod=marker spell:
set cursorcolumn

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
Plug 'tpope/vim-eunuch'
" }



" Windows {
Plug 'drn/zoomwin-vim'
" }

" async library for vim plugins such as unite
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" COMPLETION and SNIPPETS {
"Plug 'SirVer/ultisnips'
"Plug 'Shougo/neocomplete.vim'
"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'
Plug 'ervandew/supertab'
"Plug 'honza/vim-snippets'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'SirVer/ultisnips'
" }


" Navigation: Fuzzy Find, Vimfiler, Tags , etc {
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'justinmk/vim-dirvish'
Plug 'ludovicchabant/vim-gutentags'
"
" "}


" Syntax/Linting  {
Plug 'scrooloose/syntastic'
" }

" Language Plugins {
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"}


"SEARCH {
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
"}

" Motion and Text Objects {
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
"}

Plug 'haya14busa/incsearch.vim'

Plug 'tmhedberg/matchit'

" Color Schemes {
Plug 'flazz/vim-colorschemes'
"https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
Plug 'rakr/vim-one'
"}

" Table Alignment and Editing Plugins {
Plug 'junegunn/vim-easy-align'
" }


" Light weight status line. airline/powerline suck
" From https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
Plug 'bluz71/vim-moonfly-statusline'


Plug 'airblade/vim-rooter'


" Add plugins to &runtimepath
call plug#end()


exec 'source'. g:vimCfgDir . '/basic-keymap.vim'
let s:cfgs=split(globpath(g:vimCfgDir, '*cfg.vim'), '\n')
for s:cfg in s:cfgs
	exec ":source " . s:cfg
endfor









