" vim: set sw=2 ts=2 sts=2 et tw=80 foldmarker={,} foldlevel=0 foldmethod=marker spell:

" NOTE {
"   Tarun Ramakrishna Elankath's vimrc file. Been using VIM for 12 years now. 
"   Re-created from scratch on Aug 20, 2011
"   Re-created from scratch again on Aug 6, 2016, taking the best parts from YADR
"   Extensively modified in period Aug, 2017
"   Decision to ditch vim and use only neovim in 5th May, 2018
"   https://github.com/lenkite/dotfiles
" }

" { * Directs neovim to use vim config. 
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
" }

