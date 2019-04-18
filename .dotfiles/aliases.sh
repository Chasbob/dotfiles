alias inet="ifconfig|grep 'inet '"

ssp(){
    ssh -L $1\:localhost\:$1 $2
}
