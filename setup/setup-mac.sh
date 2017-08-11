#!/bin/bash

if [[ `uname` == 'Darwin' ]] ; then
        osx=true
        echo "Running MacOS"
fi
#http://stackoverflow.com/questions/5756524/how-to-get-absolute-path-name-of-shell-script-on-macos
# it is really crappy that we don't have a better way to get full path to a script
export dotfilesSetupDir=$(cd "$(dirname "$0")"; pwd)
export dotfilesDir="$(dirname $dotfilesSetupDir)"
export vimconfigDir=$dotfilesDir/vimconfig
export SDKHOME=~/sdk
export sdkhome=$SDKHOME

echo "Dotfiles Dir: $dotfilesDir"
echo "VimConfig Dir: $vimconfigDir"


# Re-Create Links to zsh startup scripts
rm ~/.zshrc 2> /dev/null
rm ~/.zprofile 2> /dev/null
rm ~/.zshrc 2> /dev/null
rm ~/.zshenv 2> /dev/null
rm ~/.vimrc 2> /dev/null
rm ~/.ideavimrc 2> /dev/null
ln $dotfilesDir/zshrc ~/.zshrc
ln $vimconfigDir/vimrc ~/.vimrc
ln $vimconfigDir/ideavimrc ~/.ideavimrc



echo "Setup Dir $dotfilesSetupDir"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
