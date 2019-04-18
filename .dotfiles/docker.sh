#!/bin/zsh

alias dm='docker-machine'
alias dmx='docker-machine ssh'
alias dk='docker'
alias dki='docker images'
alias dks='docker service'
alias dkrm='docker rm'
alias dl='docker logs'
alias dlf='docker logs -f'
alias dkflush='docker rm `docker ps --no-trunc -aq`'
alias dkflush2='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias dkt='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
alias dkpsp="docker ps --format '{{.Names}} ~ {{.Ports}}'"
alias dkpsn="docker ps --format '{{.Names}}'"
dma(){
    if [ $1 != ""] [&& $2 != "" ]; then
        echo "2"
        docker-machine create --driver generic \
        --generic-ip-address=$1 \
        --generic-ssh-key ~/.ssh/id_rsa \
        --generic-ssh-user charlie \
        $2
    elif [ $1 != "" ]; then
        echo "1"
        docker-machine create --driver generic \
        --generic-ip-address=$1 \
        --generic-ssh-key ~/.ssh/id_rsa \
        --generic-ssh-user charlie \
        $1
    else
        echo "Illegal number of parameters"
    fi
}

dkln() {
  docker logs -f `docker ps | grep $1 | awk '{print $1}'`
}

dkclean() {
  docker rm $(docker ps --all -q -f status=exited)
  docker volume rm $(docker volume ls -qf dangling=true)
}

dkprune() {
  docker system prune -af
}

dktop() {
  docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}

dkstats() {
  if [ $# -eq 0 ]
    then docker stats --no-stream;
    else docker stats --no-stream | grep $1;
  fi
}

dkb() {
  docker exec -it $1 /bin/bash
}

dkexe() {
  docker exec -it $1 $2
}

dkreboot() {
  osascript -e 'quit app "Docker"'
  countdown 2
  open -a Docker
  echo "Restarting Docker engine"
  countdown 120
}

dkstate() {
  docker inspect $1 | jq .[0].State
}

dksb() {
  docker service scale $1=0
  sleep 2
  docker service scale $1=$2
}

dcra() {
  docker-compose up -d --force-recreate
}

dr(){
  docker restart $1 && docker logs -f $1
}