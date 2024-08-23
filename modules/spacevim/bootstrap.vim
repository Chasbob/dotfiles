function! bootstrap#after() abort
  let g:ale_linters = {
  \   'proto': ['buf-lint',],
  \}
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_linters_explicit = 1
  let g:ale_fix_on_save = 1
  
  " let g:yaml_limit_spell = 1
  if exists('g:spacevim_guifont') && !empty(g:spacevim_guifont)
    exe 'set guifont='.g:spacevim_guifont
  else
    set guifont=SauceCodePro\ Nerd\ Font\ Mono:h15
  endif
  " neomake
  let g:neomake_javascript_jsx_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'
  " let g:python3_host_prog = '/home/cfreitas/.SpaceVim.d/venv/bin/python'

  """"""""
  " vimtex
  """"""""
  let g:tex_fold_override_foldtext = 1
  let g:vimtex_syntax_conceal_cites = {
        \ 'type': 'icon',
        \ 'icon': '📖',
        \ 'verbose': v:true,
        \}
  let g:vimtex_format_enabled = 1
  let g:vimtex_compiler_method = 'arara'
  " let g:tex_comment_nospell = 1
  let g:tex_fold_additional_envs = ['wip', 'itemize']
  let g:tex_fold_sec_char = '>'
  let g:neomake_tex_enabled_makers = []
  let g:neomake_markdown_enabled_makers = []

  set signcolumn=yes
  let g:vimtex_compiler_arara = {
        \ 'options' : ['-l', '-p', 'full'],
      \}
  let g:vimtex_quickfix_open_on_warning = 0

  """"""""""
  " graphviz
  """"""""""
  let g:graphviz_viewer = 'xdg-open'
  let g:graphviz_output_format = 'pdf'
  let g:graphviz_shell_option = ''

  let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

  " Fugitive Conflict Resolution
  nnoremap <leader>gd :Gvdiff<CR>
  nnoremap gdh :diffget //2<CR>
  nnoremap gdl :diffget //3<CR>
  
  if exists("did_load_filetypes")
    finish
  endif
  
  augroup filetypedetect
    au BufNewFile,BufRead justfile setf make
  augroup END

  augroup tex_mappings
      autocmd!
      " autocmd FileType md,tex set spell
      autocmd FileType md,tex setl tw=79
      autocmd FileType md,tex highlight Conceal guifg=#ffffff
      autocmd FileType md,tex highlight OverLength ctermbg=grey guibg=grey
      autocmd FileType md,tex match OverLength /\%>80v.*/
      autocmd FileType md,tex set formatoptions-=t
      autocmd FileType md,tex map \gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
      autocmd FileType md,tex omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>
  augroup END


  " set tabstop=2 shiftwidth=2 expandtab
  " autocmd FileType make setlocal noexpandtab
  autocmd FileType make set noexpandtab shiftwidth=2 softtabstop=0
  " autocmd BufWritePre *.md normal gqip
  autocmd BufWritePost *.dot GraphvizCompile
" require("jenkinsfile_linter").validate()
  autocmd BufWritePost Jenkinsfile :lua require("jenkinsfile_linter").validate()
  " autocmd BufWritePost Jenkinsfile !curl -n -X POST -H "$(curl -n 'https://jenkins-2.risq.uk/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)')" -n https://jenkins-2.risq.uk/pipeline-model-converter/validate < %
endfunction

function! bootstrap#before() abort
  set exrc
  set secure
  set timeoutlen=400

  call SpaceVim#custom#SPCGroupName(['k'], '+Mine')
  call SpaceVim#custom#SPC('nore', ['k', 'f'], 'normal gqip', 'format para', 1)
  nmap <silent> <leader>sb ysis*gvS*

  " let g:python3_host_prog = '~/.SpaceVim.d/venv/bin/python'
  let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-q', '-'],
    \ }
  " let g:neoformat_enabled_python = ['black', 'autoflake']



  let g:neoformat_basic_format_trim = 1
  let g:neomake_open_list = 0
  let profile = SpaceVim#mapping#search#getprofile('rg')
  let default_opt = profile.default_opts + ['--ignore-vcs']
  call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})

  " let g:loaded_python_provider = 0
  call SpaceVim#plugins#tasks#reg_provider(funcref('s:make_tasks'))
  call SpaceVim#plugins#tasks#reg_provider(funcref('s:just_tasks'))

endfunction

function! s:just_tasks() abort
    if filereadable('justfile')
        let subcmd = system('just --summary')
        if !empty(subcmd)
            let commands = split(subcmd)
            let conf = {}
            for cmd in commands
                call extend(conf, {
                            \ cmd : {
                            \ 'command': 'just',
                            \ 'args' : [cmd],
                            \ 'isDetected' : 1,
                            \ 'detectedName' : 'just:'
                            \ }
                            \ })
            endfor
            return conf
        else
            return {}
        endif
    else
        return {}
    endif
endfunction
" call SpaceVim#plugins#tasks#reg_provider(function('s:just_tasks'))

function! s:make_tasks() abort
    if filereadable('Makefile')
        let subcmd = filter(readfile('Makefile', ''), "v:val=~#'^.PHONY'")
        if !empty(subcmd)
            let commands = split(subcmd[0])[1:]
            let conf = {}
            for cmd in commands
                call extend(conf, {
                            \ cmd : {
                            \ 'command': 'make',
                            \ 'args' : [cmd],
                            \ 'isDetected' : 1,
                            \ 'detectedName' : 'make:'
                            \ }
                            \ })
            endfor
            return conf
        else
            return {}
        endif
    else
        return {}
    endif
endfunction

