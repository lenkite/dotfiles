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


" E for explorer
nnoremap <Leader>ee :NERDTreeToggle<Enter>
nnoremap <Leader>ef :NERDTreeFind<CR>
nnoremap <Leader>eb :NERDTreeFromBookmark 
nnoremap <Leader>er :NERDTreeCWD<CR>


