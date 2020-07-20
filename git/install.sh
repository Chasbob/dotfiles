#!/bin/bash

SOURCE=$1

echo "Setup git..."
[ -e "$HOME"/.gitconfig ] && mv "$HOME"/.gitconfig{,.bak}
ln -sfn "$SOURCE"/git/.gitconfig "$HOME"/.gitconfig

