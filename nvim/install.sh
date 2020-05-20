#!/bin/bash

SOURCE=$1
DESTINATION=$2
INSTALL_PLUGINS=$3

echo "Setup init.vim..."
test -e "$DESTINATION"/nvim/init.vim && mv "$DESTINATION"/nvim/init.vim{,.bak}
test -L "$DESTINATION"/nvim/init.vim && mv "$DESTINATION"/nvim/init.vim{,.bak}
mkdir -p "$DESTINATION"/nvim
ln -s {"$SOURCE","$DESTINATION"}/nvim/init.vim

if [ "$INSTALL_PLUGINS" = true ] ; then
 type nvim && nvim --headless +PlugInstall +qall || echo "nvim not installed, skipping plugin installation"
fi
