#!/bin/bash

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_CONFIG_HOME"/zinit
ZINIT[BIN_DIR]="$ZINIT[HOME_DIR]"/bin
ZINIT[PLUGINS_DIR]="$ZINIT[HOME_DIR]"/plugins
ZINIT[COMPLETIONS_DIR]="$ZINIT[HOME_DIR]"/completions
ZINIT[SNIPPETS_DIR]="$ZINIT[HOME_DIR]"/snippets
ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME"/.zcompdump
ZPFX="$ZINIT[HOME_DIR]"/polaris

## Add zinit module
if [[ -f "${ZINIT[BIN_DIR]}/zmodules/Src/zdharma/zplugin.so" ]]; then
  module_path+=( "${ZINIT[BIN_DIR]}/zmodules/Src" )
      zmodload zdharma/zplugin
fi

### Added by Zinit's installer
if [[ ! -f ${ZINIT[BIN_DIR]}/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${ZINIT[BIN_DIR]}" && command chmod g-rwX "${ZINIT[BIN_DIR]}"
    command git clone https://github.com/zdharma/zinit "${ZINIT[BIN_DIR]}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT[BIN_DIR]}/zinit.zsh"
autoload -Uz _zinit
autoload "$ZDOTDIR"/funcs/*
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-meta-plugins

zinit bindmap'^R -> ^F' for \
  annexes zsh-users+fast zdharma console-tools fuzzy

### End of Zinit's installer chunk

zinit lucid as"null" for \
  has"gsed" id-as"gsed" sbin"$(which gsed) -> sed" zdharma/null \
  has"ggrep" id-as"ggrep" sbin"$(which ggrep) -> grep" zdharma/null \
  has"gdircolors" id-as"gdircolors" sbin"$(which gdircolors) -> dircolors" zdharma/null

bindkey '^e' autosuggest-accept
bindkey '^x' autosuggest-execute
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zstyle :plugin:history-search-multi-word reset-prompt-protect 1

# Programs
zinit wait lucid from"gh-r" as"null" for \
    from"github" src"asdf.sh" as"program" \
    @asdf-vm/asdf \
    sbin"docker* -> docker-compose" has"docker" \
    docker/compose \
    sbin"**/step -> step" \
    smallstep/cli \
    sbin"direnv" mv"direnv* -> direnv" atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh" \
    direnv/direnv \
    sbin"yank" from"github" make \
    mptre/yank \
    sbin"shfmt* -> shfmt" \
    @mvdan/sh \
    from"github" as"program" src"forgit.plugin.zsh" \
    wfxr/forgit

# Completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    svn \
    as"completion" \
      OMZP::docker \
    svn has"kubectl" \
      OMZP::kubectl \
    svn \
      OMZP::docker-compose \
    svn \
      OMZP::gradle \
    svn \
      OMZP::colored-man-pages \
    as"completion" mv"contrib/completions.zsh -> _exa" id-as"exa-comp" \
      ogham/exa \
    as"completion" mv"autocomplete/zsh_autocomplete -> _step" id-as"step-comp" \
      smallstep/cli

# Theme
zinit depth=1 lucid atload"source $ZDOTDIR/p10k.zsh; _p9k_precmd" nocd for \
    romkatv/powerlevel10k


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

typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=true
typeset -g ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# if gpg is installed
# make sure the agent is running
zinit \
      wait \
      lucid \
      has"gpgconf" \
      if"[ ! -S $GNUPGHOME/S.gpg-agent.ssh ]" \
      atinit"gpgconf --launch gpg-agent" for \
         zdharma/null

(( ! ${+functions[p10k]} )) || p10k finalize
