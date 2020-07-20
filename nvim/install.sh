#!/bin/bash

SOURCE=$1
DESTINATION=$2
INSTALL_PLUGINS=$3

echo "Setup init.vim..."
mkdir -p "$DESTINATION"/nvim
ln -sb {"$SOURCE","$DESTINATION"}/nvim/init.vim

if [ "$INSTALL_PLUGINS" = true ] ; then
 type nvim && nvim --headless +PlugInstall +qall || echo "nvim not installed, skipping plugin installation"
fi
