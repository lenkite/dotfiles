if [[ $isCygwin ]]; then
  gvim() {
    gvimExe="/c/PROGRA~2/Vim/vim80/gvim.exe"
    $(unset TERM && $gvimExe $*)
  }
fi
