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

