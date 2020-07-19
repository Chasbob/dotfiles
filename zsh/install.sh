#!/bin/bash

SOURCE=$1

ZDOTDIR=$SOURCE/zsh
echo "Setup .zshenv..."
[ -h "$HOME"/.zshenv ] && unlink "$HOME"/.zshenv
[ -e "$HOME"/.zshenv ] && mv "$HOME"/.zshenv{,.bak}
ln -s "$ZDOTDIR"/.zshenv "$HOME"/.zshenv
