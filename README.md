# Dotfiles

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/chasbob/dotfiles?style=plastic) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chasbob/dotfiles?style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/chasbob/dotfiles?style=plastic) ![GitHub](https://img.shields.io/github/license/chasbob/dotfiles)

This is my oh my zsh and powerlevel 9k setup, setup as described [here](https://www.atlassian.com/git/tutorials/dotfiles).\
This repository contains copies of [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) and [Powerlevel9k](https://github.com/bhilburn/powerlevel9k).

## Install

**Files that would have been overwriten are renamed with the suffix `.bak`**

### Install everything

```bash
$ git clone --recursive https://github.com/Chasbob/dotfiles.git ~/.config/dotfiles
$ ~/.config/dotfiles/install.sh
```

> **Can be cloned to anly path**

### Install plugins

```bash
$ INSTALL_PLUGINS=true ~/.config/dotfiles/install.sh
```

> Applies to zsh and nvim

### Install individual configs

all of the following can be grouped in any way in the form of:

```bash
$ ~/.config/dotfiles/install.sh zsh nvim alacritty tmux
```

## Preview

You can use docker to view the setup with:

```bash
$ docker run --rm -ti chasbob/dotfiles:master
```
