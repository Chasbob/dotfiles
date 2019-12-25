#!/bin/sh

DOTFILES_ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
echo DOTFILES_ROOT=$DOTFILES_ROOT | cat - $DOTFILES_ROOT/default.zshrc > $DOTFILES_ROOT/.zshrc

ln -sf $DOTFILES_ROOT/.zshrc ~/.zshrc