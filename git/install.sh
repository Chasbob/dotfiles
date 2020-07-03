#!/bin/bash

SOURCE=$1

echo "Setup git..."
test -e "$SOURCE"/git/.gitconfig && mv "$HOME"/.gitconfig{,.bak}
ln -sf "$SOURCE"/git/.gitconfig "$HOME"/.gitconfig

