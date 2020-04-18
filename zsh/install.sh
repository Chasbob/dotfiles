#!/bin/bash

ZDOTDIR=$1/zsh
test -f ~/.zshenv && mv ~/.zshenv{,.bak}
sed \
  -e "s#ZDOTDIR=.*#ZDOTDIR=${ZDOTDIR}#g" \
  "$ZDOTDIR/.zshenv" > ~/.zshenv

