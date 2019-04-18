#!/bin/zsh

get-config(){
    ssh kirk sudo ./bin/get-config $1
    scp kirk:$1.ovpn .
    ssh kirk rm $1.ovpn
}
new-config(){
    ssh kirk sudo ./bin/new-config $1
    get-config $1
}
remove-config(){
    ssh kirk sudo ./bin/remove-config $1
}