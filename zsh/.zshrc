#!/bin/bash

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.

# Check if zplug is installed
if [[ ! -d $ZPLUG_HOME ]]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

. "$ZPLUG_HOME/init.zsh"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. "$ZDOTDIR/p10k.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 'core' zsh plugins
zstyle ":zplug:tag" defer 0
zstyle ":zplug:tag" depth 1
zstyle ":zplug:tag" as command
zplug "zsh-users/zsh-completions", use:'src'
zplug "zsh-users/zsh-autosuggestions", defer:2, on:"zsh-users/zsh-completions", lazy:false, as:plugin
zplug "zdharma/fast-syntax-highlighting", defer:2, on:"zsh-users/zsh-autosuggestions", lazy:false, as:plugin
zplug "zsh-users/zsh-history-substring-search", defer:3, lazy:false, as:plugin

# theme - configured with p10k.zsh
zplug "romkatv/powerlevel10k", as:theme, depth:1, lazy:false

# extras that I find rather useful
zplug 'wfxr/forgit', defer:2, as:plugin, lazy:false
zplug "hlissner/zsh-autopair", defer:2, as:plugin, lazy:false

# external aliases and completions
zplug "docker/cli", use:'contrib/completion/zsh/_docker'
zplug "plugins/docker-compose", from:oh-my-zsh, as:plugin
zplug "gradle/gradle-completion", use:_gradle
zplug "smallstep/cli", use:'autocomplete/zsh_autocomplete', rename-to:'_step'

zplug load
# Add zsh-completions to completions path
fpath=(
  "${ASDF_DIR}/completions"
  "$ZDOTDIR/completions"
  "$ZPLUG_BIN"
  "${fpath[@]}"
)

# # Setup completions
autoload -Uz compinit
autoload $ZDOTDIR/funcs/*

() {
  if [[ $# -gt 0 ]]; then
    compinit
  else
    compinit -C
  fi
} ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)

# Change this to reflect your username.
export DEFAULT_USER='chasbob'

# Setup history
. "$ZDOTDIR/hist"

# Setup zsh styles
. "$ZDOTDIR/zstyles"

# Setup PATH
. "$ZDOTDIR/paths"

# Setup CDPATH for directory completion
. "$ZDOTDIR/cdpath"

# Setup aliases
. "$ZDOTDIR/aliases"

# Setup bindkeys
. "$ZDOTDIR/bindkeys"

# Setup asdf
. "$ASDF_DIR/asdf.sh" 2>/dev/null

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

# direnv hook
# https://direnv.net/docs/installation.html
type direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

#gpgconf --launch gpg-agent

