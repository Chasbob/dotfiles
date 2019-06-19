zmodload zsh/zprof
export ZSH="$HOME/.oh-my-zsh"
export TERM="xterm-256color"
ZSH_THEME="powerlevel9k/powerlevel9k"

# ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="charlie"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=0
POWERLEVEL9K_SHORTEN_STRATEGY=absolute
POWERLEVEL9K_VPN_IP_INTERFACE=utun2
POWERLEVEL9K_IP_INTERFACE=en0

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"

plugins=(
    docker-machine
    docker-compose
    docker
    history
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
    shrink-path
)



source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

# setopt prompt_subst
PS1='%n@%m $(shrink_path -f)>'

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_GB.UTF-8

export EDITOR='vim'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

PATH=$PATH:~/bin:~/tools/flutter/bin:~/tools/android_sdk_tools/bin

source ~/.dotfiles/aliases.sh
source ~/.dotfiles/docker.sh
source ~/.dotfiles/git.sh
source ~/.dotfiles/proxmox.sh
_byobu_sourced=1 . /usr/local/Cellar/byobu/5.127/bin/byobu-launch 2>/dev/null || true
