# Dotfiles

This is my oh my zsh and powerlevel 9k setup, setup as described [here](https://www.atlassian.com/git/tutorials/dotfiles).\
This repository contains copies of [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) and [Powerlevel9k](https://github.com/bhilburn/powerlevel9k).

## Install

**Currently the install script will not handle the files already exisiting**

1. git clone --recursive https://github.com/Chasbob/dotfiles.git
2. ./dotfiles/install.sh

## Testing

You can use docker to test the setup with `docker run --rm -ti chasbob/dotfiles:master`
