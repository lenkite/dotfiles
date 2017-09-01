" vim: set foldmarker={,} foldlevel=0 f
"
"
" Allow quit via single keypress (Q)
nmap Q :qa<CR>

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

"Let <C-H> open help, obviously not as convenient has spacemacs C-H, but
"we will live with this for now.
" NOTE: I decided to use window mappings
"map <C-h> <Esc>:help 

"Window management Commands
"https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Lovely! Got from some reddit post in the VIM forum to map backspace to last used file.
nnoremap  <BS> <C-^>


" From reddit
" https://www.reddit.com/r/vim/comments/6pw5ui/what_is_the_most_diffucult_vim_command_to_enter/
" Just do a visual selection and K J will move it up & down and it'll also
" reindent the code correctly.
" Move visual block. [Tarun: This is amazing and I can't understand it, Freaky]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


"Cycle through buffers
"From http://vim.wikia.com/wiki/Cycle_through_buffers_including_hidden_buffers
"Umm finaly a shift key that works!! I shoudl use this for next/previous error
"instead!!
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

"Space and S-Space should go page down and page up!
nnoremap <Space> <C-D>
"Shift-space Doesn't work in terminal. You need to remap key in terminal
"preferences
nnoremap <S-Space> <C-U> 

"
"
"" Preview file in chrome, move me to os specific keymaps
"nnoremap <F12> :exe ':silent !open -a /Applications/Google\ Chrome.app "'<CR>
"
"
"
"" Auto indent pasted text
"nnoremap p p=`]<C-o>
"nnoremap P P=`]<C-o>
"
""<Leader>-/ for tpope's commentary
""http://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
"nmap <Leader>/ gcc
"vmap <Leader>/ gcc
"
"
""makes gj/gk move by virtual lines when used without a count, and by physical
""lines when used with a count.
""http://stackoverflow.com/questions/20975928/moving-the-cursor-through-long-soft-wrapped-lines-in-vim/21000307#21000307
"noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
"noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
"
"
"
""Location List next an previous for Syntastic
""NOT happy with this keymapping :(. I cannot
"" use ctrl-; due to shitty terminal restrictions
"nnoremap <Leader>; :lnext<CR>
"nnoremap <Leader>, :lprev<CR>
"
""TODO: Investigate these below later
"" Allows you to easily replace the current word and all its occurrences.
""nnoremap <Leader>rc :"s/\<<C-r><C-w>\>/
""vnoremap <Leader>rc y:"s/<C-r>"/
"" Allows you to easily change the current word and all occurrences to something
"" else. The difference between this and the previous mapping is that the mapping
"" below pre-fills the current word for you to change.
""nnoremap <Leader>cc :"s/\<<C-r><C-w>\>/<C-r><C-w>
""vnoremap <Leader>cc y:"s/<C-r>"/<C-r>"
""
