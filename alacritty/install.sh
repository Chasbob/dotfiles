#!/bin/bash

test -f "$2"/alacritty/alacritty.yml && mv "$2"/alacritty/alacritty.yml{,.bak}
mkdir -p "$2"/alacritty
ln -s {"$1","$2"}/alacritty/alacritty.yml