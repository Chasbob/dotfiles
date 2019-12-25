#!/bin/sh
git clone --recursive https://github.com/Chasbob/dotfiles.git
echo DOTFILES_ROOT=$PWD/dotfiles | cat - dotfiles/default.zshrc > dotfiles/.zshrc