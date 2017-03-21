" Set the compiler as cargo for rust files
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
" Add Keymappings for vim plugins on enter
autocmd VimEnter * if exists(":NERDTree") | exe "map <Leader>1 :NERDTreeToggle\<CR>" | endif
autocmd VimEnter * if exists(":FZF") | exe "map <C-p> :FZF\<CR>" | endif
