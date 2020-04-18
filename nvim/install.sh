#!/bin/bash

test -f "$2"/nvim/init.vim && mv "$2"/nvim/init.vim{,.bak}
mkdir -p "$2"/nvim
ln -s {"$1","$2"}/nvim/init.vim