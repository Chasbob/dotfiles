#!/bin/bash

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. "$ZDOTDIR/custom/p10k.zsh"

. "$ZPLUG_HOME/init.zsh"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-syntax-highlighting"

zplug "k4rthik/git-cal", as:command

zplug "b4b4r07/enhancd", use:init.sh

zplug 'wfxr/forgit'

zplug "b4b4r07/httpstat", \
    as:command, \
    use:'(*).sh', \
    rename-to:"$1"

zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf

# Can manage everything e.g., other person's zshrc
zplug "tcnksm/docker-alias", use:zshrc

zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

# Add zsh-completions to completions path
fpath=(
  "$ZDOTDIR/external/zsh-completions/src"
  "${fpath[@]}"
)

# Setup completions
autoload -Uz compinit
compinit

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

# Setup colour to use for zsh suggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#ffff00,bold,underline'

# https://sdkman.io/install
export SDKMAN_DIR="$HOME/.config/sdkman"
[[ -s "$HOME/.config/sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.config/sdkman/bin/sdkman-init.sh"

# https://github.com/pindexis/marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# direnv hook
# https://direnv.net/docs/installation.html
if type -a direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

if ! zplug check --verbose; then
  echo Please run `zplug install`
fi
zplug load
