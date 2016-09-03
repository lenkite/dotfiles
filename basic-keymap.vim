" vim: set foldmarker={,} foldlevel=0 f
"

" Change leader to <Space> because the backslash is too far away
" That means all \x commands turn into <Space>x
" The mapleader has to be set before vim-plugstarts loading all 
" the plugins.
noremap <Space> <Nop>
let mapleader = "\<Space>"

" Window Splits Easy Navigation {
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }

nnoremap <Leader>w :w<CR>
nnoremap <cr> :
snoremap <cr> :
vnoremap <cr> :


" Preview file in chrome, move me to os specific keymaps
nnoremap <F12> :exe ':silent !open -a /Applications/Google\ Chrome.app %'<CR>

"Copy & paste to system clipboard with \p and \y:  {
vmap \y "+y
vmap \d "+d
nmap \p "+p
nmap \P "+P
vmap \p "+p
vmap \P "+P
"}


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



" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

"<Leader>-/ for tpope's commentary
"http://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
nmap <Leader>/ gcc
vmap <Leader>/ gcc


"makes gj/gk move by virtual lines when used without a count, and by physical
"lines when used with a count.
"http://stackoverflow.com/questions/20975928/moving-the-cursor-through-long-soft-wrapped-lines-in-vim/21000307#21000307
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" allow quit via single keypress (Q)
map <Leader>Q :qa!<CR>

"Clear highlight on double escape
nnoremap <esc><esc> :noh<return>

"Location List next an previous for Syntastic
"NOT happy with this keymapping :(. I cannot
" use ctrl-; due to shitty terminal restrictions
nnoremap <Leader>; :lnext<CR>
nnoremap <Leader>, :lprev<CR>

"TODO: Investigate these below later
" Allows you to easily replace the current word and all its occurrences.
"nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
"vnoremap <Leader>rc y:%s/<C-r>"/
" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
"nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
"vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"
"
