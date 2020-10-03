#!/bin/bash

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -

declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_CONFIG_HOME"/zinit
ZINIT[BIN_DIR]="$ZINIT[HOME_DIR]"/bin
ZINIT[PLUGINS_DIR]="$ZINIT[HOME_DIR]"/plugins
ZINIT[COMPLETIONS_DIR]="$ZINIT[HOME_DIR]"/completions
ZINIT[SNIPPETS_DIR]="$ZINIT[HOME_DIR]"/snippets
ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME"/.zcompdump
ZPFX="$ZINIT[HOME_DIR]"/polaris
__ZINIT="${ZINIT[BIN_DIR]}/zinit.zsh"

### Add zinit module
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

. "$__ZINIT"
autoload -Uz _zinit
autoload "$ZDOTDIR"/funcs/*
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-bin-gem-node \
  zinit-zsh/z-a-meta-plugins \
  zinit-zsh/z-a-patch-dl


# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

setopt promptsubst

POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=""
zinit depth=1 lucid nocd \
      atload"source $ZDOTDIR/p10k.zsh; _p9k_precmd" for romkatv/powerlevel10k

# - - - - - - - - - - - - - - - - - - - -
# Meta Plugins
# - - - - - - - - - - - - - - - - - - - -

zinit bindmap'^R -> ^F' skip'zdharma/zsh-diff-so-fancy' for zdharma
zinit skip'fzy lotabout/skim peco/peco' for fuzzy
zinit skip'sharkdp/hexyl sharkdp/hyperfine sharkdp/vivid jonas/tig dircolors-material' for console-tools
zinit for ext-git

zinit lucid pick'/dev/null' for zsh-users/zsh-completions
zinit for marlonrichert/zsh-autocomplete

# - - - - - - - - - - - - - - - - - - - -
# Tools
# - - - - - - - - - - - - - - - - - - - -

### python poetry

zinit wait lucid for \
  darvid/zsh-poetry

zinit wait lucid from"gh-r"  mv"delta* -> delta" sbin"delta/delta" as"null" for dandavison/delta

### asdf-vm
zinit wait lucid as"null" \
    from"github" src"asdf.sh" as"program" for \
    @asdf-vm/asdf

# Source plugin specific scripts

zinit wait lucid has"java" \
      if"[ -f $ASDF_DATA_DIR/plugins/java/set-java-home.zsh ]" \
      atinit"source $ASDF_DATA_DIR/plugins/java/set-java-home.zsh" for \
        id-as"asdf-vm/java-home" zdharma/null


### direnv
zinit wait lucid \
  from"gh-r" as"null" sbin"direnv" mv"direnv* -> direnv" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh" for \
    direnv/direnv

# Completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    as"completion" \
      OMZP::docker/_docker \
    has"kubectl" \
      OMZP::kubectl \
    OMZP::docker-compose \
    as"completion" \
      OMZP::docker-compose/_docker-compose \
    OMZP::gradle \
    OMZP::colored-man-pages \
    as"completion" mv"contrib/completions.zsh -> _exa" id-as"ogham/exa-comp" \
      ogham/exa \
    as"completion" mv"autocomplete/zsh_autocomplete -> _step" id-as"smallstep/cli-comp" \
      smallstep/cli

#### Setup history

HISTSIZE=99999
HISTFILESIZE=999999
SAVEHIST=$HISTSIZE
HISTFILE=$ZDOTDIR/zhistory
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# zsh-autocomplete
zstyle ':autocomplete:list-choices:*' min-input 3
zstyle ':autocomplete:*' groups always
zstyle ':autocomplete:tab:*' completion select
zstyle ':autocomplete:list-choices:*' max-lines 100%

# Setup zsh styles
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# create vim style cursor
# https://archive.emily.st/2013/05/03/zsh-vi-cursor/
function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2 / alacritty
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# Some completion fancy stuff from
# https://github.com/emilyst/home/blob/dfd57e6a753d7d15e97015dea7ef175944550343/.zshrc#L69

zmodload -i zsh/complist
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*::::' _expand completer _complete _match _approximate

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

zstyle ':completion:*' extra-verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name '' # completion in distinct groups

# allow one error for every four characters typed in approximate completer
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/4 )) numeric )'

# case- and hyphen-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# complete .. and .
zstyle ':completion:*' special-dirs true

# colors
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# offer indices before parameters in array subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# offer completions for directories from all these groups
zstyle ':completion:*::*:(cd|pushd):*' tag-order path-directories directory-stack

# never offer the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# don't complete things which aren't available
zstyle ':completion:*:*:-command-:*:*' tag-order 'functions:-non-comp *' functions
zstyle ':completion:*:functions-non-comp' ignored-patterns '_*'

# why doesn't this do anything?
zstyle ':completion:*:*:-command-:*:*' tag-order - path-directories directory-stack

# split options into groups
zstyle ':completion:*' tag-order \
    'options:-long:long\ options
     options:-short:short\ options
     options:-single-letter:single\ letter\ options'
zstyle ':completion:*:options-long' ignored-patterns '[-+](|-|[^-]*)'
zstyle ':completion:*:options-short' ignored-patterns '--*' '[-+]?'
zstyle ':completion:*:options-single-letter' ignored-patterns '???*'

# Setup PATH
PATH=$HOME/.local/bin:$XDG_CONFIG_HOME/poetry/bin:$PATH
# PATH=$HOME/.local/bin:$(find $XDG_CONFIG_HOME -mindepth 1 -maxdepth 2 -type d -name bin | tr '\n' ':' | sed 's/:*$//'):$PATH

export PATH

# Setup CDPATH for directory completion
setopt autocd
setopt autopushd

CDPATH=.:$HOME/Projects
#
# export CDPATH

# Setup aliases
# Setup open alias
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
else
  alias o='xdg-open'
  # alias xclip to pbcopy and paste
  if [ $+commands[xclip] ]; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# Add get aliase for downloading with progress
if [ $+commands[curl] ]; then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif [ $+commands[wget] ]; then
  alias get='wget --continue --progress=bar --timestamping'
fi

# Serve PWD over http
if [ $+commands[python3] ]; then
  alias http-serve='python3 -m http.server'
else
  alias http-serve='python -m SimpleHTTPServer'
fi

alias grep='grep --color=always --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias lanip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Alias NeoVim for Vim
if [ $+commands[nvim] ]; then
  alias vim='nvim'
fi

if [ $+commands[step-cli] ]; then
  alias step='step-cli'
fi

alias inet='ifconfig | grep "inet "'
alias inet6='ifconfig | grep "inet6 "'
alias o='open .'
alias wanip='dig @resolver1.opendns.com ANY myip.opendns.com +short'
alias dots='pushd $DOTDIR/'
alias zdots='pushd $ZDOTDIR'
alias gs='git status'
alias lspath='echo "$PATH" | tr ":" "\n"'
alias lsfpath='echo "$fpath" | tr " " "\n"'

alias ls='exa'
alias la='ls -la'
alias ll='ls --tree'
alias nsl='nslookup'
alias cdt='pushd $(mktemp -d)'

alias dps="docker ps --format='table | {{.ID}} ~ {{.Names}} |'"
alias dpsi="docker inspect --format='| {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} |'"
alias dpsp="docker ps --format='table | {{.ID}} ~ {{.Names}} ~ {{ .Ports }} |'"
alias drm="docker ps -aq | xargs docker rm"
alias dstop="docker ps -aq | xargs docker stop"

alias restart-dns-macos='sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias .......='../../../../../..'
alias ........='../../../../../../..'

# Setup bindkeys
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

bindkey '^e' autosuggest-accept
bindkey '^x' autosuggest-execute
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zstyle :plugin:history-search-multi-word reset-prompt-protect 1
zstyle ":history-search-multi-word" page-size "LINES/4"


# Place cursor at the end of the line when searching history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# bind up and down arrows to search history
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Bind home and end keys to start and end of line
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line

# Enable Vi mode in ZSH
bindkey -v
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=1

(( ! ${+functions[p10k]} )) || p10k finalize

