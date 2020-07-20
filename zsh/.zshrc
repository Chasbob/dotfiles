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
module_path+=( "${ZINIT[BIN_DIR]}/zmodules/Src" )
    zmodload zdharma/zplugin

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
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# Plugins
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start; bindkey '^e' autosuggest-accept; bindkey '^x' autosuggest-execute" \
        zsh-users/zsh-autosuggestions \
    atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
        zsh-users/zsh-history-substring-search \
    bindmap'^R -> ^F' \
        zdharma/history-search-multi-word \
        wfxr/forgit \
        hlissner/zsh-autopair \
        OMZP::colored-man-pages \
    atclone"$(type gdircolors >/dev/null && echo "g")dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”; zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}' \
        trapd00r/ls_colors

# Completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
        zsh-users/zsh-completions \
        OMZP::kubectl \
    as"completion" \
        OMZP::gradle/_gradle \
        OMZP::gradle \
    as"completion" \
        OMZP::docker-compose/_docker-compose \
        OMZP::docker-compose \
    as"completion" \
        OMZP::docker/_docker \
    as"completion" \
    cp"contrib/completions.zsh -> _exa" \
    id-as"exa-comp" \
        ogham/exa \

# Programs
zinit wait lucid from"gh-r" as"program" for \
        junegunn/fzf-bin \
    mv"**/fd -> fd" \
    pick"fd" \
        @sharkdp/fd \
    mv"**/bat -> bat" \
        @sharkdp/bat \
    mv"exa* -> exa" \
        ogham/exa \
    atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' \
    pick"direnv" \
    src"zhook.zsh" \
    mv"direnv* -> direnv" \
        direnv/direnv \
    mv"docker* -> docker-compose" \
        docker/compose \
    pick"yank" \
    mv"yank* -> yank" \
    make \
        mptre/yank \
    from"github" \
    src"asdf.sh" \
    atclone"ln -s ${ZINIT[PLUGINS_DIR]}/asdf-vm---asdf/completions/_asdf ${ZINIT[COMPLETIONS_DIR]}/_asdf" \
        @asdf-vm/asdf

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

[ -S "$GNUPGHOME"/S.gpg-agent.ssh ] || gpgconf --launch gpg-agent

(( ! ${+functions[p10k]} )) || p10k finalize
