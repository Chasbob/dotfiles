#!/bin/bash

SOURCE=$1
DESTINATION=$2

test -e "$DESTINATION"/nvim/init.vim && mv "$DESTINATION"/nvim/init.vim{,.bak}
test -L "$DESTINATION"/nvim/init.vim && mv "$DESTINATION"/nvim/init.vim{,.bak}
mkdir -p "$DESTINATION"/nvim
ln -s {"$SOURCE","$DESTINATION"}/nvim/init.vim