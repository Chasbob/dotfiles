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

. "$ZDOTDIR/custom/p10k.zsh"

zplug 'zplug/zplug'

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting",       defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "hlissner/zsh-autopair",                  defer:2

zplug "romkatv/powerlevel10k", as:theme

zplug 'wfxr/forgit'

zplug "junegunn/fzf", from:github, use:"shell/completion.zsh"

# Can manage everything e.g., other person's zshrc
zplug "tcnksm/docker-alias", use:zshrc
zplug "plugins/gpg-agent", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/gradle-completion", from:oh-my-zsh

zplug "MichaelAquilina/zsh-you-should-use"
zplug "sharkdp/fd", as:command, from:gh-r, rename-to:fdd
zplug "dandavison/delta", as:command, from:gh-r, rename-to:delta
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf


# Add zsh-completions to completions path
fpath=(
  "${ASDF_DIR}/completions"
  "$ZDOTDIR/funcs/*"
  "$ZDOTDIR/external/zsh-completions/src"
  "${fpath[@]}"
)

# Setup completions
autoload -Uz compinit
autoload $ZDOTDIR/funcs/*
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Change this to reflect your username.
export DEFAULT_USER='chasbob'

# Setup history
. "$ZDOTDIR/custom/hist"

# Setup zsh styles
. "$ZDOTDIR/custom/zstyles"

# Setup PATH
. "$ZDOTDIR/custom/paths"

# Setup CDPATH for directory completion
. "$ZDOTDIR/custom/cdpath"

# Setup functions
. "$ZDOTDIR/custom/funcs"

# Setup aliases
. "$ZDOTDIR/custom/aliases"

# Setup bindkeys
. "$ZDOTDIR/custom/bindkeys"

# asdf related imports
. "$ZDOTDIR/custom/asdf"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# direnv hook
# https://direnv.net/docs/installation.html
if which direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

zplug load


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
