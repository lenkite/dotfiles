autocmd VimEnter * if exists(":FZF") | exe "map <C-p> :FZF\<CR>" | endif
