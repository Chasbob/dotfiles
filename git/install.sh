#!/bin/bash

SOURCE=$1

echo "Setup git..."
test -e "$SOURCE"/git/.gitconfig && mv "$HOME"/.gitconfig{,.bak}
test -L "$SOURCE"/git/.gitconfig && mv "$HOME"/.gitconfig{,.bak}
ln -s git/.gitconfig "$HOME"/.gitconfig

