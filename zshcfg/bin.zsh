# Set up ~/bin with executables

# This seems useless since I need to set the path in setup-paths.ps1 anyways
#
[[ -d ~/bin ]] || mkdir ~/bin
[[ -d ~/.fzf/bin ]] || mkdirs ~/.fzf/bin

if [[ $isWsl == true || $isCygwin == true ]]; then
  ctags=~/src/ctags/ctags.exe
  [[ -f $ctags ]] || cp $ctags ~/bin

  fzf=~/.fzf/bin/fzf.exe
  [[ -f $fzf ]] || curl
fi

