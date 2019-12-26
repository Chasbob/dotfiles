#!/bin/sh

DOTFILES_ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
echo DOTFILES_ROOT=$DOTFILES_ROOT | cat - $DOTFILES_ROOT/default.zshrc > $DOTFILES_ROOT/.zshrc

ln -sf $DOTFILES_ROOT/.zshrc ~/.zshrc
ln -sf $DOTFILES_ROOT/.vimrc ~/.vimrc
ln -sf $DOTFILES_ROOT/vim ~/.vim
ln -sf $DOTFILES_ROOT/tmux ~/.tmux
ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
cp ~/.tmux/.tmux.conf.local ~/
vim +PluginInstall +qall