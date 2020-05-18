#!/bin/bash

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME"/dotfiles/zsh
export ZPLUG_HOME="$XDG_CONFIG_HOME/zplug"
export ZSH_CACHE_DIR="$ZPLUG_HOME/repos/robbyrussell/oh-my-zsh/cache/"

export ASDF_DIR="$XDG_CONFIG_HOME/asdf"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/dotfiles/asdf/config"
export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="$XDG_CONFIG_HOME/dotfiles/asdf/defaults"

export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"

export EDITOR="nvim"
export VISUAL="nvim"
export ENHANCD_COMMAND="ecd"
export ENHANCD_FILTER="fzf"

export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export FZF_CTRL_T_COMMAND="fdd -I --type file"
