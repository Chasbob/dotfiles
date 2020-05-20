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
zplug "zsh-users/zsh-completions",              defer:0, depth:1
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting",       defer:2, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3

# theme - configured with p10k.zsh
zplug "romkatv/powerlevel10k", as:theme, depth:1

# extras that I find rather useful
zplug 'wfxr/forgit',                            defer:2
zplug "hlissner/zsh-autopair",                  defer:2

# external aliases and completions
zplug "tcnksm/docker-alias", use:zshrc, lazy:true
zplug "docker/cli", use:contrib/completion/zsh/_docker, lazy:true
zplug "docker/compose", use:contrib/completion/zsh/_docker-compose, lazy:true
zplug "gradle/gradle-completion", use:_gradle, lazy:true
zplug "smallstep/cli", use:autocomplete/zsh_autocomplete, lazy:true

zplug load
# Add zsh-completions to completions path
fpath=(
  "${ASDF_DIR}/completions"
  "$ZDOTDIR/completions"
  "$ZDOTDIR/external/zsh-completions/src"
  "${fpath[@]}"
)

# # Setup completions
autoload -Uz compinit
# allows functions to be stored as individual files and auto-loaded by filename
autoload $ZDOTDIR/funcs/*
setopt EXTENDEDGLOB
for dump in "$XDG_CACHE_HOME"/zsh/zcompdump(#qN.m1); do
  compinit
  if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
    zcompile "$dump"
  fi
done
unsetopt EXTENDEDGLOB
compinit -C

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

# Setup functions
. "$ZDOTDIR/funcs"

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

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

