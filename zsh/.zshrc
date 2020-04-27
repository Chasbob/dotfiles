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

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting",       defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"

zplug "romkatv/powerlevel10k", as:theme

zplug 'wfxr/forgit'

zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
zplug "junegunn/fzf", from:github, use:"shell/completion.zsh"

# Can manage everything e.g., other person's zshrc
zplug "tcnksm/docker-alias", use:zshrc
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/gradle-completion", from:oh-my-zsh

zplug "lukechilds/zsh-nvm"
# zplug "matthieusb/zsh-sdkman"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "sharkdp/fd", as:command, from:gh-r, rename-to:fdd
zplug "dandavison/delta", as:command, from:gh-r, rename-to:delta

# Add zsh-completions to completions path
fpath=(
  "$ZDOTDIR/external/zsh-completions/src"
  "${fpath[@]}"
)

# Setup completions
autoload -Uz compinit
compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
# 	compinit;
# else
# 	compinit -C;
# fi;

# Change this to reflect your username.
compdef fdd='fd'
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
if which direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if which pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

 # Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  echo "Run zplug status"
fi
zplug load


echo "done in $SECONDS seconds"
