export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel9k/powerlevel9k"
DEFAULT_USER="charlie"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique

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

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

PATH=$PATH:~/bin:~/tools/flutter/bin:~/tools/android_sdk_tools/bin

# export ANDROID_HOME="/Users/charlie/tools"
#source <(kubectl completion zsh)

# list IPv4 addresses
alias inet="ifconfig|grep 'inet '"
# kill byobu
alias reset-byobu="ps aux | grep byobu | awk '{print \$2}' | xargs kill"
alias c="clear"
alias nsl="nslookup"


# git aliases
alias gc="git commit"
alias gs="git status"
alias ga="git add"
# ssh and open port
ssp(){
    ssh -L $1\:localhost\:$1 $2
}

# find by name and hide errors
fn() {
    find . -name $1 2>/dev/null
}
# run a task against all maven poms found
all_pom() {
    for pom in $(find . -name "pom.xml" 2>/dev/null)
    do
        mvn $1 -f $pom
    done
}

# proxmox qm
# get vmid
qmid(){
    qm list | grep " $1 " | awk '{print $1}'
}
# run qm commands on kirk
qm(){
    if [ $# -eq 2 ]; then
        VID=$(ssh -t kirk sudo qm list | grep " $2 " | awk '{print $1}')
        ssh -t kirk sudo qm $1 $VID 2>/dev/null
    elif [ $# -eq 1 ]; then
        ssh -t kirk sudo qm $1 2>/dev/null
    elif [ $# -eq 0 ]; then
        echo "Give some arguments."
    fi
}


# docker machine
alias dm='docker-machine'
alias dmx='docker-machine ssh'
alias dmls='docker-machine ls -t 1'
# add new docker machine
dma(){
        docker-machine create --driver generic \
        --generic-ip-address=$1 \
        --generic-ssh-key ~/.ssh/id_rsa \
        --generic-ssh-user charlie \
        $2
}
# connect to docker machine
dms() {
  eval $(docker-machine env $1)
  echo $DOCKER_HOST
}

# docker compose
alias dc='docker-compose'
alias dcc='docker-compose config'
alias duplf="docker-compose up -d && docker-compose logs -f"
dcra() {
  docker-compose up -d --force-recreate
}

alias d='docker'
alias di='docker images'
alias ds='docker service'
alias drm='docker rm'
alias dl='docker logs'
alias dlf='docker logs -f'
alias dt='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
alias dps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
alias dpsp="docker ps --format '{{.Names}} ~ {{.Ports}}'"
alias dpsn="docker ps --format '{{.Names}}'"



# find container by string and follow logs
dkln() {
  docker logs -f `docker ps | grep $1 | awk '{print $1}'`
}

dtest(){
  docker ps | grep $1 | awk '{print $1}'
}

dtop() {
  docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# print container stats
dstats() {
  if [ $# -eq 0 ]
    then docker stats --no-stream;
    else docker stats --no-stream | grep $1;
  fi
}
# open bash shell in container
db() {
  docker exec -it $1 /bin/bash
}
# launch a temporary ubuntu container
dub() {
    docker run --rm -ti ubuntu bash
}

dstate() {
  docker inspect $1 | jq .[0].State
}

dr(){
  docker restart $1 && docker logs -f $1
}



