#!/bin/bash

SOURCE=$1
# takes one argument of the parent directory path
echo "Setup .tmux directory"
ln -sb "$SOURCE/tmux" "$HOME"/.tmux

echo "Setup .tmux.conf"
ln -sb "$HOME"/.tmux/.tmux.conf "$HOME"/.tmux.conf

echo "Setup .tmux.conf.local"
ln -sb "$HOME"/.tmux/.tmux.conf.local "$HOME"/.tmux.conf.local
