#!/bin/bash

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_CONFIG_HOME"/zinit
ZINIT[BIN_DIR]="$XDG_CONFIG_HOME"/zinit/bin
ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME"/.zcompdump

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
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit wait"1b" lucid as"null" for \
  has"gsed" id-as"gsed" sbin"$(which gsed) -> sed" zdharma/null \
  has"ggrep" id-as"ggrep" sbin"$(which ggrep) -> grep" zdharma/null \
  has"gdircolors" id-as"gdircolors" sbin"$(which gdircolors) -> dircolors" zdharma/null

# Plugins
zinit wait"1c" lucid for \
    atinit"zicompinit; zicdreplay"                                         zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start; \
            bindkey '^e' autosuggest-accept; \
            bindkey '^x' autosuggest-execute"                              zsh-users/zsh-autosuggestions \
    atload"bindkey '^[[A' history-substring-search-up;\
            bindkey '^[[B' history-substring-search-down"                  zsh-users/zsh-history-substring-search \
    bindmap'^R -> ^F'                                                      zdharma/history-search-multi-word \
                                                                           wfxr/forgit \
                                                                           hlissner/zsh-autopair \
                                                                           OMZP::colored-man-pages \
                                                                           darvid/zsh-poetry \
    atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”; \
            zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}' trapd00r/ls_colors

# Completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    cp"contrib/completions.zsh -> _exa" \
    as"completion" id-as"exa-comp"        ogham/exa \
                                          zsh-users/zsh-completions \
                                          OMZP::kubectl \
    as"completion"                        OMZP::gradle/_gradle \
                                          OMZP::gradle \
    as"completion"                        OMZP::docker-compose/_docker-compose \
                                          OMZP::docker-compose \
    as"completion"                        OMZP::docker/_docker

# Programs
zinit wait"1a" lucid from"gh-r" as"null" for \
    sbin"fzf"                                  junegunn/fzf-bin \
    sbin"**/fd"                                @sharkdp/fd \
    sbin"**/bat"                               @sharkdp/bat \
    sbin"exa* -> exa"                          ogham/exa \
    sbin"docker* -> docker-compose"            docker/compose \
    sbin"direnv" \
      mv"direnv* -> direnv" \
      atclone'./direnv hook zsh > zhook.zsh' \
      atpull'%atclone' \
      src"zhook.zsh"                           direnv/direnv \
    sbin"yank" from"github" make               mptre/yank \
    from"github" src"asdf.sh"                  @asdf-vm/asdf

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
