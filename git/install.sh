#!/bin/bash

SOURCE=$1

echo "Setup git..."
echo "**** gitconfig ****"
[ -e "$HOME"/.gitconfig ] && mv "$HOME"/.gitconfig{,.bak}
ln -sfn "$SOURCE"/git/gitconfig "$HOME"/.gitconfig

echo "**** gitignore ****"
[ -e "$HOME"/.gitignore ] && mv "$HOME"/.gitignore{,.bak}
ln -sfn "$SOURCE"/git/gitignore "$HOME"/.gitignore
