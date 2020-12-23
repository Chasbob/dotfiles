function! bootstrap#after() abort
  let g:neomake_javascript_eslint_maker =  {
        \ 'exe': 'npx',
        \ 'args': ['--quiet', 'eslint', '--format=compact'],
        \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
        \   '%W%f: line %l\, col %c\, Warning - %m,%-G,%-G%*\d problems%#',
        \ 'cwd': '%:p:h',
        \ 'output_stream': 'stdout',
        \ }
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

  let g:neoformat_enabled_javascript = ['npxprettier']
  let g:neoformat_verbose = 1
endfunction

function! bootstrap#before() abort
  let g:github_dashboard = { 'username': 'chasbob', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'chasbob'
  set timeoutlen=600
endfunction
