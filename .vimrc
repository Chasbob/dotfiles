set nocompatible              " be iMproved, required
filetype off                  " required

" enable syntax highlighting
syntax on

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END
" let vim_markdown_preview_pandoc=1


