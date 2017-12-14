#!/bin/bash 
# Setups up dotfiles for use on various OS'es. 
# Supported OS'es are Windows/Cygwin, Windows/WSL, MacOS and Linux
# Dev Note: Some funcs here are duplicated in zshcfg/0.zsh. This is by design

usage() { echo "Usage: $0 [-c] [-v] [-t] [-u] [-z]" 1>&2; exit 1; }

# Use getopt for simple option parsing
# See https://stackoverflow.com/questions/16483119/example-of-how-to-use-getopts-in-bash
# See http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts "cvtuz" opt; do
  case "${opt}" in
    c)
      codeSetup=true
      ;;
    v)
      viSetup=true
      ;;
    t)
      tmuxSetup=true
      ;;
    u)
      utilSetup=true
      ;;
    z)
      zshSetup=true
      ;;
    \?)  
      usage
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done
shift $((OPTIND-1))

[ $codeSetup ] || [ $viSetup ] || [ $tmuxSetup ] || [ $utilSetup ] || [ $zshSetup ] || allSetup=true

echo "codeSetup = $codeSetup, viSetup = $viSetup, tmuxSetup = $tmuxSetup, zshSetup = $zshSetup, utilSetup = $utilSetup, allSetup=$allSetup"

setup_main() {
  initialize_vars

	if [[ $allSetup == true && $isWsl == true ]]; then
		replace_linux_home_shell
	fi


  export dotfilesSetupDir="$dotfilesDir/setup"

  if [[ -d $dotfilesDir ]]; then
    echo "Dotfiles dir already exists. Updating..."
    git -C $dotfilesDir pull
  else
    echo "Cloning dotfiles into $dotfilesDir"
    git clone https://github.com/lenkite/dotfiles $dotfilesDir
  fi


  if [[ ! -d $dotfilesSetupDir ]]; then
    echo "Error: $dotfilesSetupDir does not exist! Have you checked out dotfiles correctly?"
    exit -1
  fi
  echo "Dotfiles Dir: $dotfilesDir"

  [ $allSetup ] && install_pkgs
  [[ $allSetup || $zshSetup ]] && setup_zsh
  [[ $allSetup || $tmuxSetup ]] && setup_tmux
  [[ $viSetup || $allSetup ]] && setup_vim
  [[ $codeSetup || $allSetup ]] && setup_vscode
  [[ $utilSetup || $allSetup ]] && setup_util
  
}

initialize_vars() {
  echo "Detect host enrivornment and initializ variables.."
  [ $done_detect_os ] || detect_os
  [ $done_set_uservars ] || set_uservars
  [ $done_set_homevars ] || set_homevars
  [ $dotfilesDir ] || detect_dotfilesdir
}

detect_os() {
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
  export done_detect_os=true
}

detect_dotfilesdir() {
  export dotfilesDir=$trueHome/dotfiles
}

set_uservars() {
  linUser=`whoami`
  if [[ $isCygwin == true ]]; then
    winUser=$linUser
  fi

  if [[ $isWsl == true ]]; then
	  winUser=$(get_windows_user)
  fi
  export done_set_uservars=true
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
  export done_set_homevars=true
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
    echo "Replacing WSL home shell to ZSH.."
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
  brew install zsh git the_silver_searcher fortune cowsay
 elif [[ $isLinux == true ]]; then
  sudo apt-get update
  sudo apt-get install git zsh silversearcher-ag netcat-openbsd dh-autoreconf autoconf pkg-config tmux 7zip
 elif [[ $isCygwin == true ]]; then
   if [[ -f /tmp/apt-cyg ]]; then
     rm /tmp/apt-cyg
   fi
   echo "Attempting download of apt-cyg via wget.."
   $(cd /tmp && curl -L https://rawgit.com/transcode-open/apt-cyg/master/apt-cyg  -O )
   if [[ -f /tmp/apt-cyg ]]; then
     install /tmp/apt-cyg /bin
     echo "installed apt-cyg"
     apt-cyg install zsh
     apt-cyg install tmux
     apt-cyg install fortune
     apt-cyg install cowsay
     apt-cyg install the_silver_searcher
   else 
     echo "Could not download apt-cyg. Please download and install manually"
   fi 
 fi

 #https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
 #zplug install https://github.com/zplug/zplug
 # if command -v zsh >/dev/null 2>&1 ; then
 #  echo "Installing zplug..."
 #  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh 
 # fi


}

setup_vim() {
  initialize_vars
  echo "Setting up vim.."
  export vimConfigDir=$dotfilesDir/vimcfg
  echo "VimConfig Dir: $vimConfigDir"
  rm $trueHome/.vimrc 2> /dev/null
  rm $trueHome/_vimrc 2> /dev/null
  rm $trueHome/.ideavimrc 2> /dev/null
  ln $vimConfigDir/vimrc $trueHome/.vimrc
  ln $vimConfigDir/ideavimrc $trueHome/.ideavimrc
  echo "Setup Dir $dotfilesSetupDir"
  curl -fLo $trueHome/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

setup_tmux() {
  echo "Setting up Tmux.."
  ln $dotfilesDir/tmux.conf $trueHome/.tmux.conf
}

setup_util() {
  echo "Setting up utilities.."
  if command -v go >/dev/null 2>&1 ; then
    echo "Installing mycliutil..."
    go get -v github.com/lenkite/mycliutil/neosdkurls
  else
    echo "ERR: Go not found or not in PATH. Kindly install the same!"
  fi
}

setup_zsh() {
  initialize_vars
  echo "Setting up ZSH"
  echo "Deleting all existing .z* files from home directory.."
  rm $trueHome/.zshrc 2> /dev/null
  rm $trueHome/.zprofile 2> /dev/null
  rm $trueHome/.zshenv 2> /dev/null
  rm $trueHome/.zlogin 2> /dev/null
  rm $trueHome/.zlogout 2> /dev/null
  rm $trueHome/.zpreztorc 2> /dev/null
  echo "Deleted all existing .z* files from home directory.."

  zshCfgDir=$dotfilesDir/zshcfg
  echo "Making ZSH softlinks to files in $zshCfgDir.."
  for rcfile in $zshCfgDir/*; do
    if [[ $rcfile != *README* ]]; then
      if [[ -f $rcfile ]]; then
      echo "Executing: ln -s $rcfile $trueHome/.${rcfile##*/}"
      ln -s "$rcfile" "$trueHome/.${rcfile##*/}"
      fi
    fi
  done


  echo "Changing shell to /bin/zsh.."
  if [[ $SHELL != "/bin/zsh" ]]; then
    if [[ -z $isCygwin ]]; then
      echo "Current shell is $SHELL. Changing to /bin/zsh"
      sudo chsh -s /bin/zsh
    else
      echo "Shell SWITCH for cygwin not implemented yet. Please add line 'db_shell: /bin/zsh' in /etc/nsswitch.conf"
    fi
  fi

  if command -v git >/dev/null 2>&1 ; then
    echo "Installing zgen"
    if [ -d ~/.zgen -a -d ~/.zgen/.git ]; then
      git -C ~/.zgen reset --hard
      git -C ~/.zgen pull
    else
      git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
    fi
  else
    echo "ERROR: Could not find git and hence couldn't clone zgen :("
  fi
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

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && isSetupSourced=true

[ $isSetupSourced ] && echo "script ${BASH_SOURCE[0]} is being sourced. Execute full setup by calling\
 setup_main or individual setup_xxx functions" || setup_main

