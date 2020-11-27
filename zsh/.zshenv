#!/bin/bash

export DEFAULT_USER=chasbob

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export DOTDIR="$XDG_CONFIG_HOME/dotfiles"
export ZDOTDIR="$XDG_CONFIG_HOME/dotfiles/zsh"

export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GPG_TTY="$(tty)"

export STEPPATH="$XDG_CONFIG_HOME/step"

export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"
export TERM=xterm-256color

export EDITOR="nvim"
export VISUAL="nvim"
export LS_COLORS=$(cat $ZDOTDIR/LS_COLORS)

export FORGIT_FZF_DEFAULT_OPTS="
--exact
--border
--cycle
--reverse
--height '80%'
"

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

export COMPOSE_DOCKER_CLI_BUILD=1
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export ASDF_DATA_DIR=$XDG_CONFIG_HOME/asdf

export COMPOSE_DOCKER_CLI_BUILD=1
export ZSH_AUTOSUGGEST_USE_ASYNC=1
