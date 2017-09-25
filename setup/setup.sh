#!/bin/bash

# Setups up dotfiles for use on various OS'es. 
# Supported OS'es are Windows/Cygwin, Windows/WSL, MacOS and Linux
# Dev Note: Some funcs here are duplicated in zshcfg/0.zsh. This is by design

setup_main() {
  detect_running_os
  set_uservars
  set_homevars

	if [[ $isWsl == true ]]; then
		replace_linux_home_shell
    exit -1
	fi

  if [[ $isWsl == true ]]; then
    export dotfilesDir=$winHome/dotfiles
  else
    export dotfilesDir=$HOME/dotfiles
  fi

  #export dotfilesSetupDir=$(cd "$(dirname "$0")"; pwd)
  export dotfilesSetupDir="$dotfilesDir/setup"

  if [[ -d $dotfilesDir ]]; then
    echo "Dotfiles dir already exists. Moving to /tmp"
    rm -rf $dotfilesDir
  fi
  echo "Cloning dotfiles into $dotfilesDir"
  git clone https://github.com/lenkite/dotfiles $dotfilesDir

  #http://stackoverflow.com/questions/5756524/how-to-get-absolute-path-name-of-shell-script-on-macos
  # it is really crappy that we don't have a better way to get full path to a script

  export vimConfigDir=$dotfilesDir/vimcfg
  export preztoDir=$trueHome/.zprezto

  if [[ ! -d $dotfilesSetupDir ]]; then
    echo "Error: $dotfilesSetupDir does not exist! Have you checked out dotfiles correctly?"
    exit -1
  fi
  echo "Dotfiles Dir: $dotfilesDir"
  echo "VimConfig Dir: $vimConfigDir"

  install_pkgs
  setup_zsh
  setup_vim
  setup_vscode
  
}

detect_running_os() {
	uname=`uname`
	if [[ $uname == 'Darwin' ]]; then
		export isMacos=true
		echo "Running in MacOS"
	elif [[ $uname == 'Linux' ]]; then
		export isLinux=true
		echo "Running in Linux"
	elif [[ $uname == CYGWIN* ]]; then
		export isCygwin=true
		echo "Running in Cygwin"
	else
		echo "This Setup Script only works for Windows Cygwin, Windows Subsystem for Linux and MacOS"
		exit -1
	fi
	export osreleaseFile=/proc/sys/kernel/osrelease
	echo "Checking $osreleaseFile (if present)"
	if [[ -f  $osreleaseFile ]]; then
		osrelease=`cat $osreleaseFile`
		echo "Linux OS release is $osrelease"
		if [[ $osrelease == *Microsoft* ]]; then
			echo "Running in WSL: Windows Subystem for Linux"
			export isWsl=true
		fi
	fi
}

set_uservars() {
  linUser=`whoami`
  if [[ $isCygwin == true ]]; then
    winUser=$linUser
  fi

  if [[ $isWsl == true ]]; then
	  winUser=$(get_windows_user)
  fi
}


set_homevars() {
  if [[ $isLinux == true ]]; then
    export linHome=$HOME
    export trueHome=$linHome
    echo "Linux home: $linHome"
  fi
  if [[ $isMacos == true ]]; then
    export macHome=$HOME
    export trueHome=$macHome
    echo "Mac home: $macHome"
  fi
  if [[ $isWsl == true ]]; then
    local wh=$(/mnt/c/Windows/System32/cmd.exe '/c echo %USERPROFILE%')
    wh=${wh/$'\r'} # https://stackoverflow.com/questions/7800482/in-bash-how-do-i-replace-r-from-a-variable-that-exist-in-a-file-written-using
    winHome=${wh/\"}
    echo "Windows home is >>>$winHome<<<"
    export winHome=$(convert_wpath $winHome)
    export trueHome=$winHome
  elif [[ $isCygwin == true ]]; then
    winHome=$HOME
    export trueHome=$winHome
  fi
  echo "True home: $trueHome"
}

get_windows_user() {
	local sys32dir="/mnt/c/Windows/System32"
	local winWho=$(cd $sys32dir; whoami.exe)
	local winUser=${winWho##*\\}
	cd $cdir
	echo $winUser 
}

convert_wpath() {
  echo "$@" | sed -e 's|\\|/|g' -e 's|^\([A-Za-z]\)\:/\(.*\)|/mnt/\L\1\E/\2|'
}

replace_linux_home_shell() {
	if [[ $isWsl == true ]]; then
    cat $vimscript > /tmp/changehome.vim
		echo "Linux user is $linUser. Windows User is $winUser"
		echo "Replacing linux home directory: '$linHome' with windows home dir: '$winHome'"
    echo "Need priv to execute: sed -i.bak -e s_${linHome}_${winHome}_ -e s_/bin/bash_/bin/zsh_ /etc/passwd"
    sudo sed -i.bak -e "s_${linHome}_${winHome}_" -e s_/bin/bash_/bin/zsh_ /etc/passwd
		echo "Kindly check /etc/passwd to see if its ok"
	fi
}


install_pkgs() {
 echo " Installing packages"
 if [[ $isMacos == true ]]; then
  brew install zsh git the_silver_searcher
 elif [[ $isLinux == true ]]; then
  sudo apt-get install git zsh silversearcher-ag netcat-openbsd
 elif [[ $isCygwin == true ]]; then
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

setup_vim() {
  echo "Setting up vim.."
  rm $trueHome/.vimrc 2> /dev/null
  rm $trueHome/.ideavimrc 2> /dev/null
  ln $vimConfigDir/vimrc $trueHome/.vimrc
  ln $vimConfigDir/ideavimrc $trueHome/.ideavimrc
  echo "Setup Dir $dotfilesSetupDir"
  curl -fLo $trueHome/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_rupa_z() {
  echo "Setting up rupa z"
  if [[ "$isMacos" == true ]]; then
    brew install z
  else
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O $trueHome/.z.sh
  fi
}

setup_zsh() {
  echo "Setting up ZSH"
  echo "Deleting all existing .z* files from home directory.."
  rm $trueHome/.zshrc 2> /dev/null
  rm $trueHome/.zprofile 2> /dev/null
  rm $trueHome/.zshenv 2> /dev/null
  rm $trueHome/.zlogin 2> /dev/null
  rm $trueHome/.zlogout 2> /dev/null
  rm $trueHome/.zpreztorc 2> /dev/null
  echo "Deleted all existing .z* files from home directory.."

  if [[ -e $preztoDir ]]; then
    echo "$preztoDir exists. Updating the same"
    git -C $preztoDir submodule update --init --recursive
    git -C $preztoDir pull
  else
    echo "$preztoDir does not exist. Cloning freshly"
    git clone --recursive https://github.com/lenkite/prezto.git $preztoDir
  fi

  wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O $trueHome/z.sh

  echo "PreztoDir is $preztoDir. Making ZSH softlinks to $preztoDir./runcoms"
  for rcfile in $preztoDir/runcoms/*; do
    if [[ $rcfile != *README* ]]; then
      echo "Executing: ln -s $rcfile $trueHome/.${rcfile##*/}"
      ln -s "$rcfile" "$trueHome/.${rcfile##*/}"
    fi
  done

  if [[ $SHELL != "/bin/zsh" ]]; then
    echo "Current shell is $SHELL. Changing to /bin/zsh"
    chsh -s /bin/zsh
  fi

  install_rupa_z
  echo "Changing shell to /bin/zsh.."
  sudo chsh -s /bin/zsh
}

setup_vscode() {
  echo "Setting up vscode"
  sourceDir=$dotfilesDir/vscode
  if [[ $isMacos == true ]]; then
    targetDir="$HOME/Library/Application Support/Code/User"
  elif [[ $isCygwin == true ]]; then
    targetDir="$winHome/AppData/Roaming/Code/User"
  elif [[ $isWsl == true ]]; then
    targetDir="$winHome/AppData/Roaming/Code/User"
  elif [[ $isLinux == true ]]; then
    echo "TODO: Not sure what is VSC's target dir in real linux..check it out!"
    exit -1
    targetDir="$winHome/AppData/Roaming/Code/User"
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

if [[ "$1" != "skipExec" ]]; then
  setup_main"$@"
fi
