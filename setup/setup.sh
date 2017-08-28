#!/bin/bash

uname=`uname`
if [[ $uname == 'Darwin' ]]; then
  osx=true
  echo "Running MacOS"
elif [[ $uname == 'Linux' ]]; then
	linux=true
	echo "Running Linux"
else
  echo "This Setup Script only works for Linux and MacOS"
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

echo "Dotfiles Dir: $dotfilesDir"
echo "VimConfig Dir: $vimConfigDir"


function setup-zsh {
  rm ~/.zshrc 2> /dev/null
  rm ~/.zprofile 2> /dev/null
  rm ~/.zshenv 2> /dev/null
  rm ~/.zlogin 2> /dev/null
  rm ~/.zlogout 2> /dev/null
  rm ~/.zpreztorc 2> /dev/null

  if [[ -e $preztoDir ]]; then
    git -C $preztoDir submodule update --init --recursive
    git -C $preztoDir pull
  else
    git clone --recursive https://github.com/lenkite/prezto.git $preztoDir
  fi
  for rcfile in $preztoDir/runcoms/^README.md(.N); do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
  done
  if [[ $SHELL != "/bin/zsh" ]]; then
    echo "Current shell is $SHELL. Changing to /bin/zsh"
    chsh -s /bin/zsh
  fi

}

function setup-vim {
  rm ~/.vimrc 2> /dev/null
  rm ~/.ideavimrc 2> /dev/null
  ln $vimConfigDir/vimrc ~/.vimrc
  ln $vimConfigDir/ideavimrc ~/.ideavimrc
  echo "Setup Dir $dotfilesSetupDir"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}


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
 if [ "$osx" = true ]; then
  brew install zsh z git the_silver_searcher
 elif [ "$linux" = true]; then
  sudo apt-get install git zsh silversearcher-ag
  wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/z.sh
 fi
}

install-pkgs
setup-zsh
setup-vim
setup-vscode
