#!/bin/bash

if [[ ! -d $ASDF_DIR ]]; then
  git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR
fi

for plugin in bat fd firebase flutter gohugo gradle java neovim nodejs python ripgrep tmux; do
  echo adding "$plugin"...
  asdf plugin-add "$plugin"
done

