#!/bin/bash

test -f "$2"/nvim/init.vim && mv "$2"/nvim/init.vim{,.bak}

ln -s {"$1","$2"}/init.vim