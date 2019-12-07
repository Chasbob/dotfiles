#!/bin/sh


# ssh and open port
ssp(){
    ssh -L "$1"\:localhost\:"$1" "$2"
}

# find by name and hide errors
fn() {
    find . -name "$1" 2>/dev/null
}

newMAC(){
    ifconfig en0 | grep ether
    MAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    # echo MAC="$MAC"
    sudo ifconfig en0 ether "$MAC"
    sudo ifconfig en0 down && sudo ifconfig en0 up
    ifconfig en0 | grep ether
}

# list IPv4 addresses
alias inet="ifconfig|grep 'inet '"
alias c="clear"
alias nsl="nslookup"
alias s="spotify"
alias op="open ."
alias l="ls -lh"
alias la="ls -lah"
alias cl="clear && l"
alias cla="clear && la"
alias wanip="dig @resolver1.opendns.com ANY myip.opendns.com +short"
alias restart_en0='sudo ifconfig en0 down && sudo ifconfig en0 up'

