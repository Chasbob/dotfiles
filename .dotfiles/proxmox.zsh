#!/bin/sh

# proxmox qm
# get vmid
qmid(){
    qm list | grep " $1 " | awk '{print $1}'
}
# run qm commands on kirk
qm(){
    ssh -t kirk sudo qm $@ 2>/dev/null
}

qm-names(){
    qm list | grep "" | awk {'printf ("%s\t%s\n",$1,$2)'}
}

qmt(){
    qm list | grep -i " $2 " | awk '{print $1}' | xargs ssh -tt kirk "sudo qm $1 " 2>/dev/null
}

new-vm(){
    VMID=$$
    ssh -t kirk "sudo qm clone 103 $VMID --name $1 && sudo qm start $VMID"
}
