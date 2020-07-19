#!/bin/bash

. "$XDG_CONFIG_HOME"/zinit/zinit.zsh

# Plugins
zinit wait"1a" lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start; bindkey '^e' autosuggest-accept; bindkey '^x' autosuggest-execute" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
        zsh-users/zsh-history-substring-search \
    bindmap'^R -> ^F' \
        zdharma/history-search-multi-word \
        wfxr/forgit \
        hlissner/zsh-autopair \

# Programs
zinit wait"1b" lucid from"gh-r" as"program" for \
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

# Completions
zinit wait"1c" as"completion" lucid for \
    OMZP::docker/_docker \
    OMZP::docker-compose/_docker-compose \
    OMZP::gradle/_gradle

# Theme
# Load within zshrc – for the instant prompt
zinit ice wait'!' lucid atload"source $ZDOTDIR/p10k.zsh; _p9k_precmd" nocd
zinit light romkatv/powerlevel10k

# pretty colours
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/ls_colors

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

[ -S "$GNUPGHOME"/S.gpg-agent.ssh ] || gpgconf --launch gpg-agent


### Added by Zinit's installer
if [[ ! -f $ZDOTDIR/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$ZDOTDIR/.zinit" && command chmod g-rwX "$ZDOTDIR/.zinit"
    command git clone https://github.com/zdharma/zinit "$ZDOTDIR/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZDOTDIR/.zinit/bin/zinit.zsh"
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
