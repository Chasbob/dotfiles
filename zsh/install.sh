#!/bin/bash

SOURCE=$1
ZPLUG_HOME=$2/zplug
INSTALL_PLUGINS=$3

if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

ZDOTDIR=$SOURCE/zsh
echo "Setup .zshenv..."
[ -h "$HOME"/.zshenv ] && unlink "$HOME"/.zshenv
[ -e "$HOME"/.zshenv ] && mv "$HOME"/.zshenv{,.bak}
ln -s "$ZDOTDIR"/.zshenv "$HOME"/.zshenv

if [ "$INSTALL_PLUGINS" = true ] ; then
  type zsh && zsh -ic "zplug install" || echo "zsh not installed, skipping plugin installation"
fi
