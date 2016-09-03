" Ideally I should have shift versions of the below with the default-action
nnoremap <Leader>p :Unite -start-insert file_rec/async -default-action=split<CR>
nnoremap <Leader>y :Unite -start-insert tag  -default-action=split<CR>
nnoremap <Leader>e :Unite -quick-match -default-action=split -short-source-names buffer file/async<CR>
nnoremap \\ :VimFilerExplorer <CR>
let g:vimfiler_as_default_explorer = 1
let g:unite_source_rec_async_command =
      \ ['ag', '--follow', '--nocolor', '--nogroup',  '--hidden', '-g', '']

"nnoremap <leader>ft :Unite file_rec/async -default-action=tabopen
"nnoremap <leader>fs :Unite file_rec/async -default-action=split
"nnoremap <leader>fv :Unite file_rec/async -default-action=vsplit
"nnoremap <leader>fc :Unite file_rec/async
