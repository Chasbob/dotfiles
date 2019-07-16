zmodload zsh/zprof
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM=$HOME/.zsh_custom
export TERM="xterm-256color"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'

DEFAULT_USER="charlie"

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"

plugins=(
    docker-machine
    docker-compose
    docker
    history
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

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

# Darwin is the architecture name for macOS systems
if [[ "$(uname)" == "Darwin" ]]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

PATH=$PATH:~/bin:~/tools/flutter/bin:~/tools/android_sdk_tools/bin

source ~/.dotfiles/aliases.zsh
source ~/.dotfiles/docker.zsh
source ~/.dotfiles/git.zsh
source ~/.dotfiles/proxmox.zsh
_byobu_sourced=1 . /usr/local/Cellar/byobu/5.127/bin/byobu-launch 2>/dev/null || true
source ~/.purepower