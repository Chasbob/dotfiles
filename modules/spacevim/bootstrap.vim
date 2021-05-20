function! bootstrap#after() abort
  " neomake
  let g:neomake_javascript_jsx_enabled_makers = ['eslint']
  let g:neomake_javascript_eslint_exe = $PWD .'/node_modules/.bin/eslint'
  let g:python3_host_prog = '/usr/bin/python3'
  " vimtex
  let g:tex_fold_override_foldtext = 1
  let g:vimtex_syntax_conceal_cites = {
        \ 'type': 'icon',
        \ 'icon': '📖',
        \ 'verbose': v:true,
        \}
  let g:vimtex_format_enabled = 1
  let g:vimtex_compiler_method = 'arara'
  let g:tex_fold_additional_envs = ['wip', 'itemize']
  let g:tex_fold_sec_char = '>'
  let g:neomake_tex_enabled_makers = []

  let g:vimtex_compiler_arara = {
        \ 'options' : ['-l', '-p', 'full'],
      \}
  let g:vimtex_quickfix_open_on_warning = 0

  " style
  set guifont=JetbrainsMono\ Nerd\ Font\ Mono:h15
  " highlight Conceal guifg=#ffffff
  set langmenu=en_GB.UTF-8

  
  augroup tex_mappings
      autocmd!
      autocmd FileType md,tex set spell
      autocmd FileType md,tex setl tw=79
      autocmd FileType md,tex highlight Conceal guifg=#ffffff
      autocmd FileType md,tex highlight OverLength ctermbg=grey guibg=grey
      autocmd FileType md,tex match OverLength /\%>80v.*/
      autocmd FileType md,tex set formatoptions-=t
      autocmd FileType md,tex map \gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
      autocmd FileType md,tex omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>
  augroup END

  if exists("did_load_filetypes")
    finish
  endif
  
  augroup filetypedetect
    au BufNewFile,BufRead justfile setf make
  augroup END

  " set tabstop=2 shiftwidth=2 expandtab
  " autocmd FileType make setlocal noexpandtab
  autocmd FileType make set noexpandtab shiftwidth=2 softtabstop=0
endfunction

function! bootstrap#before() abort
  set exrc
  set secure
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

  let g:neomake_open_list = 0
  " let g:indent_guides_enable_on_vim_startup = 1
  " augroup MyColors
      " autocmd!
      " autocmd ColorScheme * call MyHighlights()
  " augroup END
  " colorscheme foobar
  let profile = SpaceVim#mapping#search#getprofile('rg')
  let default_opt = profile.default_opts + ['--ignore-vcs']
  call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})

  let g:loaded_python_provider = 0
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
                echom cmd
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

