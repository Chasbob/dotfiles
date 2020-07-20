#!/bin/bash

SOURCE=$1
DESTINATION=$2

echo "Setup alacritty.yml..."
mkdir -p "$DESTINATION"/alacritty
ln -sb {"$SOURCE","$DESTINATION"}/alacritty/alacritty.yml

