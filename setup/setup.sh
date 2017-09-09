#!/bin/bash

uname=`uname`
if [[ $uname == 'Darwin' ]]; then
  macos=true
  echo "Running MacOS"
elif [[ $uname == 'Linux' ]]; then
	linux=true
	echo "Running Linux"
elif [[ $uname == CYGWIN* ]]; then
  cygwin=true
  echo "Running in Cygwin"
else
  echo "This Setup Script only works for Windows Cygwin, Windows Subsystem for Linux and MacOS"
  exit -1
fi

osreleaseFile=/proc/sys/kernel/osrelease
echo "Checking $osreleaseFile (if present)"
if [[ -f  $osreleaseFile ]]; then
  osrelease=`cat $osreleaseFile`
  echo "Linux OS release is $osrelease"
  if [[ $osrelease == *Microsoft* ]]; then
    echo "Running in Windows Subystem for Linux"
    wsl=true
  fi
fi

user=`whoami`
echo "Hello $user!"

if [[ "$wsl" == true ]]; then
  echo "Linux user is $user. Windows User is TODO"
  echo "Replacing /home/$user /etc/passwd"
  echo "TODO"
  exit -1
fi


#http://stackoverflow.com/questions/5756524/how-to-get-absolute-path-name-of-shell-script-on-macos
# it is really crappy that we don't have a better way to get full path to a script
export dotfilesSetupDir=$(cd "$(dirname "$0")"; pwd)
export dotfilesDir="$(dirname $dotfilesSetupDir)"
export vimConfigDir=$dotfilesDir/vimcfg
export SDKHOME=~/sdk
export sdkhome=$SDKHOME
export preztoDir=$HOME/.zprezto

if [[ ! -d $dotfilesSetupDir ]]; then
  echo "Error: $dotfilesSetupDir does not exist! Have you checked out dotfiles correctly?"
  exit -1
fi

echo "Dotfiles Dir: $dotfilesDir"
echo "VimConfig Dir: $vimConfigDir"


function setup-zsh {
  echo "Deleting all existing .z* files from home directory.."
  rm ~/.zshrc 2> /dev/null
  rm ~/.zprofile 2> /dev/null
  rm ~/.zshenv 2> /dev/null
  rm ~/.zlogin 2> /dev/null
  rm ~/.zlogout 2> /dev/null
  rm ~/.zpreztorc 2> /dev/null
  echo "Deleted all existing .z* files from home directory.."

  if [[ -e $preztoDir ]]; then
    echo "$preztoDir exists. Updating the same"
    #git -C $preztoDir submodule update --init --recursive
    #git -C $preztoDir pull
  else
    echo "$preztoDir does not exist. Cloning freshly"
    git clone --recursive https://github.com/lenkite/prezto.git $preztoDir
  fi

  echo "PreztoDir is $preztoDir. Making ZSH softlinks to $preztoDir./runcoms"
  for rcfile in $preztoDir/runcoms/*; do
    if [[ $rcfile != *README* ]]; then
      echo "Executing: ln -s $rcfile $HOME/.${rcfile##*/}"
      ln -s "$rcfile" "$HOME/.${rcfile##*/}"
    fi
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



function install-pkgs {
  echo " Installing packages"
 if [[ "$macos" == true ]]; then
  brew install zsh z git the_silver_searcher
 elif [[ "$linux" == true ]]; then
  sudo apt-get install git zsh silversearcher-ag
  wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/z.sh
 elif [[ "$cygwin" == true ]]; then
   if [[ -f /tmp/apt-cyg ]]; then
     rm /tmp/apt-cyg
   fi
   echo "Attempting download of apt-cyg via lynx.."
   lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > /tmp/apt-cyg
   if [[ "$?" == 127 ]]; then
     echo "Attempting download of apt-cyg via wget.."
     wget  https://rawgit.com/transcode-open/apt-cyg/master/apt-cyg  -O /tmp/apt-cyg 
   fi
   if [[ -f /tmp/apt-cyg ]]; then
     install /tmp/apt-cyg /bin
     echo "installed apt-cyg"
   else 
     echo "Could not download apt-cyg. Please download and install manually"
   fi 
 fi
}

function setup-vscode {
  sourceDir=$dotfilesDir/vscode
  if [[ $macos == true ]]; then
    targetDir="$HOME/Library/Application Support/Code/User"
  elif [[ $cygwin == true ]]; then
    targetDir="$HOME/AppData/Roaming/Code/User/"
  fi
  if [[ -e $targetDir/keybindings.json ]]; then
    echo "Deleting existing vscode keybindings.json"
    rm $targetDir/keybindings.json 2> /dev/null
  fi
  echo "Executing ln -s $sourceDir/keybindings.json $targetDir"
  ln -s "$sourceDir/keybindings.json" "$targetDir"


  if [[ -e $targetDir/settings.json ]]; then
    echo "Deleting existing vscode settings.json"
    rm $targetDir/settings.json 2> /dev/null
  fi
  echo "Executing ln -s $sourceDir/settings.json $targetDir"
  ln -s "$sourceDir/settings.json" "$targetDir"
}
install-pkgs
setup-zsh
setup-vim
setup-vscode
