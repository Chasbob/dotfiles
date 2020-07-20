# Dotfiles

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/chasbob/dotfiles?style=plastic) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chasbob/dotfiles?style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/chasbob/dotfiles?style=plastic) ![GitHub](https://img.shields.io/github/license/chasbob/dotfiles)

These are my dotfiles.

## Install

**Files that would have been overwriten are renamed with the suffix `.bak`**

### Install everything

```bash
$ git clone --recursive https://github.com/Chasbob/dotfiles.git ~/.config/dotfiles
$ ~/.config/dotfiles/install.sh
```

### Install plugins

```bash
$ INSTALL_PLUGINS=true ~/.config/dotfiles/install.sh
```

> Applies to zsh

### Install individual configs

All of the following can be grouped in any way in the form of:

```bash
$ ~/.config/dotfiles/install.sh zsh nvim alacritty tmux
```

## Preview

You can use docker to view the set-up with:

```bash
$ docker run --rm -ti chasbob/dotfiles:master
```
