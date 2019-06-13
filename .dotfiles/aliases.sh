#!/bin/sh


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

# list IPv4 addresses
alias inet="ifconfig|grep 'inet '"
# kill byobu
alias reset-byobu="ps aux | grep byobu | awk '{print \$2}' | xargs kill"
alias c="clear"
alias nsl="nslookup"
alias s="spotify"
alias op="open ."
