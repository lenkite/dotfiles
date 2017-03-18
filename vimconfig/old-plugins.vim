" vim: set foldmarker={,} foldlevel=1 foldmethod=marker:

" NOTE {
" THE BELOW ASSUMES THAT YOU HAVE INSTALLED " vim-plug https://github.com/junegunn/vim-plug
"   Tarun Ramakrishna Elankath's vimrc file. Been using VIM for 8 years now. 
"   Re-created from scratch on Aug 20, 2011
"   https://github.com/lenkite/dotfiles
" }

" PLUGINS PRE-CONFIGURATION Variables  {
let g:cargo_makeprg_params='build'
" }


" PLUGINS INSTALLATION {
call plug#begin('~/.vim/plugged')

" async library for vim plugins such as unite
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" COMPLETION and SNIPPETS {
"Plug 'Valloric/YouCompleteMe'
"Plug 'SirVer/ultisnips'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
"Plug 'ervandew/supertab'
Plug 'honza/vim-snippets'
" }

" Navigation: Fuzzy Find, Nerd Tree, Tag Bar, etc{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
"
" "}
" Syntax Checking
Plug 'scrooloose/syntastic'

" Rust Lang plugin
Plug 'rust-lang/rust.vim'

" TPope plugins: Bracket mappings, surround, comment, repeat
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fireplace'



" UNITE Plugins {
"Plug 'Shougo/unite.vim'
"Plug 'Shougo/unite-outline'
"Plug 'tsukkee/unite-tag'
"Plug 'Shougo/vimfiler'
"}

" Motion and Text Objects {
Plug 'easymotion/vim-easymotion'
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

Plug 'justinmk/vim-sneak'

Plug 'airblade/vim-rooter'



" Add plugins to &runtimepath
call plug#end()


" }
"











