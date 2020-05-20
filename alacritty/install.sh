#!/bin/bash

SOURCE=$1
DESTINATION=$2

echo "Setup alacritty.yml..."
test -e "$DESTINATION"/alacritty/alacritty.yml && mv "$DESTINATION"/alacritty/alacritty.yml{,.bak}
test -L "$DESTINATION"/alacritty/alacritty.yml && mv "$DESTINATION"/alacritty/alacritty.yml{,.bak}
mkdir -p "$DESTINATION"/alacritty
ln -s {"$SOURCE","$DESTINATION"}/alacritty/alacritty.yml

