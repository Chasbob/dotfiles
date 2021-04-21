function! bootstrap#after() abort
  let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

  let g:neomake_javascript_jsx_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'
  let g:python3_host_prog = '/usr/bin/python3'
  if exists("did_load_filetypes")
    finish
  endif

  " autocmd FileType make setlocal noexpandtab
  autocmd FileType make set noexpandtab shiftwidth=2 softtabstop=0
  augroup filetypedetect
    au BufNewFile,BufRead justfile setf make
  augroup END
endfunction

function! bootstrap#before() abort
  let g:github_dashboard = { 'username': 'chasbob', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'chasbob'
  set timeoutlen=600
  let g:coc_global_extensions = [
        \'coc-json',
        \'coc-git',
        \'coc-prettier',
        \'coc-css',
        \'coc-jedi',
        \'coc-html',
        \'coc-snippets',
        \'coc-ultisnips',
        \'coc-vimtex',
        \'coc-docker',
        \'coc-go',
        \'coc-java']

  let g:indent_guides_enable_on_vim_startup = 1
endfunction
