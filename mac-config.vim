set macmeta "Enables  Alt-/M- key mappings on MacVim
macmenu File.Print key=<nop>
" Ideally I should have shift versions of the below with the default-action
nnoremap <D-p> :Unite -start-insert -short-source-names file_rec/async -default-action=split <CR>
nnoremap <D-y> :Unite -start-insert tag --default-action=split <CR>
nnoremap <D-e> :Unite -quick-match -short-source-names buffer file/async -default-action=split <CR>
nmap <D-/> gcc
vmap <D-/> gcc
