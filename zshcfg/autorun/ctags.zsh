# Set up ~/bin with executables

# This seems useless since I need to set the path in setup-paths.ps1 anyways
#
[[ -d ~/bin ]] || mkdir ~/bin

if [[ $isWsl == true || $isCygwin == true ]]; then
  ctags=~/src/ctags/ctags.exe
  [[ -f $ctags ]] && cp $ctags ~/bin
fi

