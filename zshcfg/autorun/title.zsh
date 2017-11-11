# Change title of MinTTY to current dir
function settitle() {
    [ $isCygwin ] && echo -ne "\033]2;"$1"\007"
}
if [[ $isCygwin ]]; then
  function chpwd() {
    settitle $(cygpath -m `pwd`)
  }
fi
