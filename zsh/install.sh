#!/bin/bash


SOURCE=$1

ZDOTDIR=$SOURCE/zsh
test -e ~/.zshenv && mv ~/.zshenv{,.bak}
test -L ~/.zshenv && mv ~/.zshenv{,.bak}
sed \
  -e "s#ZDOTDIR=.*#ZDOTDIR=${ZDOTDIR}#g" \
  "$ZDOTDIR/.zshenv" > ~/.zshenv

