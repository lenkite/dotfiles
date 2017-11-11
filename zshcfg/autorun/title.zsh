# Change title of MinTTY to current dir
function settitle() {
    [ $isCygwin ] && echo -ne "\033]2;"$1"\007"
}
function chpwd() {
    settitle $(cygpath -m `pwd`)
}
