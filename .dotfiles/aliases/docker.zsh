#!/bin/sh

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
# unset docker machine
dmus() {
      unset $(env | grep DOCKER | awk -F'=' '{print $1}' | xargs)
}

# docker compose
alias dc='docker-compose'
alias dcc='docker-compose config'
alias dcuplf="docker-compose up -d && docker-compose logs -f"
alias dcup="docker-compose up"
alias dcupd="docker-compose up -d"
alias dcps="docker-compose ps"
alias dclf="docker-compose logs -f"
alias dcdn="docker-compose down"
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

# grep container logs
dlfg(){
    docker logs -f $1 2>&1 | grep $2
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
