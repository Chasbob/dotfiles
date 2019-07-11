#!/bin/sh

# proxmox qm
# get vmid
qid(){
    qm list | grep " $1 " | awk '{print $1}'
}
# run qm commands on kirk
qm(){
    ssh -t kirk "sudo qm $*" 2>/dev/null
}

qidn(){
    qm list | grep "" | awk \{'printf ("%s\t%s\n",$1,$2)'\}
}

qn(){
    qm list | grep "\d" | awk \{'printf ("%s\n",$2)'\}
}

qmn(){
    VMID=$(qm list | grep -i " $2 " | awk '{print $1}')
    #  | xargs -I VMID ssh -t kirk "sudo qm $1 VMID"
    # qmid "$VMID"
    echo "sudo qm $1 $VMID"
    ssh -t kirk "sudo qm $1 $VMID" 2>/dev/null
}

newVM(){
    VMID=$(jot -w %i -r 1 100000)
    [ -n "$2" ] && VMID="$2"
    # echo VMID: "$VMID"
    # echo 2: "$2"
    ssh -t kirk "sudo qm clone 103 $VMID --name $1 && sudo qm start $VMID"
}

newNode(){
    VMID=$(jot -w %i -r 1 100000)
    [ -n "$2" ] && VMID="$2"
    ssh -t kirk "sudo qm clone 500 $VMID --name $1 && sudo qm start $VMID"
}