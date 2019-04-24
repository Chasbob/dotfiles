alias inet="ifconfig|grep 'inet '"

ssp(){
    ssh -L $1\:localhost\:$1 $2
}

# find by name
fn() {
    find . -name $1 2>/dev/null
}
all_pom() {
    for pom in $(find . -name "pom.xml" 2>/dev/null)
    do
        mvn $1 -f $pom
    done
}
