# Dotfiles

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/chasbob/dotfiles?style=plastic) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chasbob/dotfiles?style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/chasbob/dotfiles?style=plastic) ![GitHub](https://img.shields.io/github/license/chasbob/dotfiles)

These are my dotfiles.

## Includes

### ZSH

> Loaded with zinit

#### Plugins

* [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
* [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
* [zdharma/history-search-multi-word](https://github.com/zdharma/history-search-multi-word)
* [wfxr/forgit](https://github.com/wfxr/forgit)
* [hlissner/zsh-autopair](https://github.com/hlissner/zsh-autopair)
* [trapd00r/ls_colors](https://github.com/trapd00r/ls_colors)

##### Plugins - Oh My Zsh
https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/

* [gradle](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gradle)
* [docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)
* [docker-compose](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose)
* [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)

#### Programs - loaded with zinit

* [junegunn/fzf-bin](https://github.com/junegunn/fzf-bin)
* [sharkdp/fd](https://github.com/sharkdp/fd)
* [sharkdp/bat](https://github.com/sharkdp/bat)
* [ogham/exa](https://github.com/ogham/exa)
* [direnv/direnv](https://github.com/direnv/direnv)
* [docker/compose](https://github.com/docker/compose)
* [mptre/yank](https://github.com/mptre/yank)
* [asdf-vm/asdf](https://github.com/asdf-vm/asdf)


#### Theme

[powerlevel10k](https://github.com/romkatv/powerlevel10k)

### Neovim

* COC requires `node`
* wakatime needs an api key

> Either make sure these are done or remove corresponding parts from [init.vim](./nvim/init.vim)

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

You can use this [docker image](https://hub.docker.com/r/chasbob/dotfiles) to view the set-up with:

```bash
$ docker run --rm -ti chasbob/dotfiles
```
