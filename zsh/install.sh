#!/bin/bash

SOURCE=$1
INSTALL_PLUGINS=$2

ZDOTDIR=$SOURCE/zsh
echo "Setup .zshenv..."
[ -h "$HOME"/.zshenv ] && unlink "$HOME"/.zshenv
[ -e "$HOME"/.zshenv ] && mv "$HOME"/.zshenv{,.bak}
ln -s "$ZDOTDIR"/.zshenv "$HOME"/.zshenv

if [ "$INSTALL_PLUGINS" = true ] ; then
  type zsh && zsh -ic "zplug install" || echo "zsh not installed, skipping plugin installation"
fi
