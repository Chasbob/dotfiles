#!/bin/bash

SOURCE=$1

echo "Setup SpaceVim..."
mkdir -p "$HOME"/autoload
echo "**** init.toml ****"
[ -e "$HOME"/.SpaceVim.d/init.toml ] && mv "$HOME"/.SpaceVim.d/init.toml{,.bak}
ln -sfn "$SOURCE"/SpaceVim/init.toml "$HOME"/.SpaceVim.d/init.toml

echo "**** bootstrap.vim ****"
[ -e "$HOME"/.SpaceVim.d/autoload/bootstrap.vim ] && mv "$HOME"/.SpaceVim.d/autoload/bootstrap.vim{,.bak}
ln -sfn "$SOURCE"/SpaceVim/bootstrap.vim "$HOME"/.SpaceVim.d/autoload/bootstrap.vim
