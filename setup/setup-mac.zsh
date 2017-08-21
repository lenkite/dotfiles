#!/bin/zsh

if [[ `uname` == 'Darwin' ]] ; then
  osx=true
  echo "Running MacOS"
else
  echo "This Setup Script only works for MacOS"
  return -1
fi
#http://stackoverflow.com/questions/5756524/how-to-get-absolute-path-name-of-shell-script-on-macos
# it is really crappy that we don't have a better way to get full path to a script

export dotfilesSetupDir=$(cd "$(dirname "$0")"; pwd)
export dotfilesDir="$(dirname $dotfilesSetupDir)"
export vimConfigDir=$dotfilesDir/vimcfg
export SDKHOME=~/sdk
export sdkhome=$SDKHOME
export preztoDir=$HOME/.zprezto
  setopt EXTENDED_GLOB

echo "Dotfiles Dir: $dotfilesDir"
echo "VimConfig Dir: $vimConfigDir"


source $dotfilesSetupDir/setup-common.zsh


function setup-vscode {
  sourceDir=$dotfilesDirs/vscode
  targetDir="$HOME/Library/Application Support/Code/User"
  [[ -f "$targetDir/keybindings.json" ]]  && echo "keybindings exists"
  [[ -f ~/.zshrc ]]  && echo "zshrc file exists"
  if [[ -e $targetDir/keybindings.json ]]; then
    echo "Deleting existing vscode keybindings.json"
    rm $targetDir/keybindings.json 2> /dev/null
  fi
  ln -s $sourceDir/keybindings.json $targetDir
}

function install-pkgs {
  brew install z
}

install-pkgs
setup-zsh
setup-vim
setup-vscode


