#!/bin/sh

# proxmox qm
# get vmid
qmid(){
    qm list | grep " $1 " | awk '{print $1}'
}
# run qm commands on kirk
qm(){
    if [ $# -eq 2 ]; then
        VID=$(ssh -t kirk sudo qm list 2>/dev/null | grep " $2 " | awk '{print $1}')
        ssh -t kirk sudo qm $1 $VID 2>/dev/null
    elif [ $# -eq 1 ]; then
        ssh -t kirk sudo qm $1 2>/dev/null
    elif [ $# -eq 0 ]; then
        echo "Give some arguments."
    fi
}