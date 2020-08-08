#!/bin/bash 
# Setups up dotfiles for use on various OS'es. 
# Supported OS'es are Windows/Cygwin, Windows/WSL, MacOS and Linux
# Dev Note: Some funcs here are duplicated in zshcfg/0.zsh. This is by design

usage() { echo "Usage: $0 [-c] [-p] [-v] [-t] [-u] [-z]" 1>&2; exit 1; }

# Use getopt for simple option parsing
# See https://stackoverflow.com/questions/16483119/example-of-how-to-use-getopts-in-bash
# See http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts "cmpsuvtz" opt; do
  case "${opt}" in
    c)
      codeSetup=true
      ;;
    p)
      pkgSetup=true
      ;;
    m)
      miscSetup=true
      ;;
    s)
      sdkSetup=true
      ;;
    u)
      utilSetup=true
      ;;
    v)
      viSetup=true
      ;;
    z)
      zshSetup=true
      ;;
    t)
      settingsSetup=true
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

[ $codeSetup ] || [ $pkgSetup ] || [ $miscSetup ] || [ $utilSetup ] || [ $viSetup ] || [ $zshSetup ] || [ $sdkSetup ] || [ $settingsSetup ] || allSetup=true

echo "codeSetup = $codeSetup, sdkSetup = $sdkSetup, viSetup = $viSetup, miscSetup = $miscSetup, zshSetup = $zshSetup, utilSetup = $utilSetup, settingsSetup = $settingsSetup, allSetup=$allSetup"

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

  [[ $allSetup  || $pkgSetup  ]] && install_pkgs
  [[ $allSetup  || $zshSetup  ]] && setup_zsh
  [[ $viSetup   || $allSetup  ]] && setup_vim
  [[ $sdkSetup  || $allSetup  ]] && setup_sdk
  [[ $codeSetup || $allSetup  ]] && setup_code
  [[ $utilSetup || $allSetup  ]] && setup_util
  [[ $settingsSetup || $allSetup ]] && setup_settings
  [[ $allSetup  || $miscSetup ]] && setup_misc
  
}

initialize_vars() {
  echo "- initialize_vars"
  echo "Detect host enrivornment and initialize variables.."
  [ $done_detect_os ] || detect_os
  [ $done_set_uservars ] || set_uservars
  [ $done_set_homevars ] || set_homevars
  [ $dotfilesDir ] || detect_dotfilesdir
  detect_util
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
  [[ -f /etc/redhat-release ]] &&  export isRedhat=true
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

detect_util() {
  hasCurl=$(command -v curl)
  hasZip=$(command -v zip)
  hasUnzip=$(command -v unzip)
  hasGit=$(command -v git)
  hasGo=$(command -v go)
  ctags --help > /dev/null 2>&1
  [[ $? -ge 0 ]] && hasCtags=false || hasCtags=true
  [[ hasCurl ]] || echo "WARN: 'curl' not found. Setup may be incomplete"
  [[ hasCtags ]] || echo "WARN: 'ctags' not found or GNU version not installed"
  [[ hasZip ]] || echo "WARN: 'zip' not found. Setup may be incomplete"
  [[ hasUnzip ]] || echo "WARN: 'unzip' not found. Setup may be incomplete"
  [[ hasGit ]] || echo "WARN: 'git' not found. Setup may be incomplete and need to be rerun"

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

gh_download_linux_release() {
	if [[ -z $1 ]]; then
		echo "(gh_download_linux_release) user/org needed for first param"
		exit 1
	fi
	
	if [[ -z $2 ]]; then
		echo "(gh_download_linux_release) repo name needed as second param"
		exit 1
	fi

  if [[ -z $3 ]]; then
    echo "(gh_download_linux_release) filter string (valid grep regex) needed as third param"
		exit 1
  fi
	local filter=$3
  local latestRelUrl="https://api.github.com/repos/$1/$2/releases/latest"
  # Uncomment only for debugging since bash funcs are like commands and can't give proper return values
	#echo "(gh_download_linux_release) Querying : $latestRelUrl"
  local downloadUrl=$(curl -s $latestRelUrl | grep browser_download_url | grep $filter | cut -d '"' -f 4)
	if [[ -z $downloadUrl ]]; then
		echo "(gh_download_linux_release) Failed to obtain release info form: $latestRelUrl"
		exit 2
	fi
	local downloadPath="/tmp/${downloadUrl##*/}"
	# Uncomment only for debugging
	#echo "(gh_download_linux_release) Downloading into $downloadPath from $downloadUrl"
	local res=$(cd /tmp && curl -s -k -O -L -C - $downloadUrl)
	local downloadResult=$?
	[[ -f $downloadPath ]]  || ( echo "Could not download: $downloadUrl"  && return 3 )
	echo $downloadPath
	return $downloadResult
}

install_pkgs() {
 echo "- (install_pkgs) Installing packages..."
 if [[ $isMacos == true ]]; then
   #brew install git || brew upgrade git 
    brew install the_silver_searcher fortune cowsay upgrade cowsay jenv leiningen nodejs go rlwrap yarn neovim jenv
    brew cask install skim 
 elif [[ $isLinux == true ]]; then
   if [[ $isRedhat == true ]]; then
     install_pkgs_redhat
   else
     echo "** NOTE: If RUNNING BEHIND PROXY, export http_proxy/https_proxy"
     sudo -E add-apt-repository -y ppa:neovim-ppa/unstable
     sudo -E add-apt-repository ppa:webupd8team/java
     # BEGIN: Nodejs install. Taken from https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
     curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
     sudo apt-get install -y nodejs
     # END : Nodejs install
     sudo -E apt-get --yes install git curl zsh silversearcher-ag netcat-openbsd dh-autoreconf \
       autoconf pkg-config tmux fortune-mod cowsay zip unzip python3 python3-pip ruby \
       vim neovim nodejs rar unrar oracle-java8-installer rlwrap yarn
            sudo apt-get -y autoremove
     fi
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

 if command -v pip3 >/dev/null 2>&1 ; then
   echo "INSTALL python neovim modules using pip3..."
   pip3 install --user pynvim
   echo "INSTALL conan package manager ..."
   pip3 install --user conan #conan will be added in ~/Library/Python/3.7/bin/conan. Needs new shell
   #pip3 install neovim --upgrade
   #pip3 install --user neovim-remote
 else
   echo "WARN: can't find pip3!"
 fi

 #https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
 #zplug install https://github.com/zplug/zplug
 # if command -v zsh >/dev/null 2>&1 ; then
 #  echo "Installing zplug..."
 #  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh 
 # fi

}

install_pkgs_redhat() {
  echo "- (install_pkgs_redhat) Using Yum to install packages..."
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_COLLATE=C
  export LC_CTYPE=en_US.UTF-8
  sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum install -y neovim python3-neovim
}

setup_go_linux() {
  echo "-- setup_go_linux"
	local needVersion="1.11.2"
  local gotarbin="go$needVersion.linux-amd64.tar.gz"
  local goroot="/usr/local/go"
	[[ $hasGo ]] && goVersion=$(go version | cut -d " " -f3)
  if [[ $hasCurl && $isLinux ]]; then
		if [[ ! $goVersion == "go$needVersion" ]]; then
		  echo "(setup_go_linux) Go version: $goVersion "
			pushd /tmp
			curl -L -O -C - https://dl.google.com/go/$gotarbin
			#[[ -d $goroot ]] && echo "setup_go_linux: $goroot already exists. Skip extraction of $gotarbin" || sudo tar -C /usr/local -zxf $gotarbin
			[[ -d /usr/local/go ]] && sudo rm -rf /usr/local/go
      echo "Untarring $gotarbin..."
			sudo tar -C /usr/local -zxf $gotarbin
			popd
			echo "(setup_go_linux) Go has been installed"
		else 
			echo "(setup_go_linux) Go already at version $needVersion"
		fi
  else
    echo "WARNING: Curl not found or not in PATH. Kindly install the same!"
  fi

  if [[ $isMacos == true ]]; then
      # TODO check for upgrade option too
      [[ $hasGo ]] && brew upgrade golang || brew install golang
  fi
}

setup_maven() {
  # I would love to use pkg manager here but sadly the pkg managers are out of date!
  echo "-- setup_maven"
#	local mvnVersion="3.5.4"
#  local mvnName="apache-maven-$mvnVersion"
#  local mvnTar="$mvnName-bin.tar.gz"
#  local mvnUrl="http://www.strategylions.com.au/mirror/maven/maven-3/$mvnVersion/binaries/$mvnTar"
#  if [[ $hasCurl && $isLinux ]]; then
#		echo " (setup_maven) Downloading: $mvnUrl"
#    [[ -f /tmp/$mvnTar ]] || $(cd /tmp && curl -O -L $mvnUrl)
#    sudo tar -C /tmp -xzf /tmp/$mvnTar
#		[[ -d /opt/maven ]] && sudo rm -rf /opt/maven
#    sudo mv /tmp/$mvnName /opt/maven
#    echo " (setup_maven) done"
#  fi

  if [[ $isMacos ]]; then
      brew install maven --ignore-dependencies	
  fi
}

setup_jdk() {
  echo "-- setup_jdk"
  if [[ $isLinux ]]; then
    echo "(setup_jdk) NOT YET IMPLEMENTED FOR LINUX"
  fi
  if [[ $isMacos ]]; then
	echo "(setup_jdk) Installing Oracle JDK 8"
  brew tap homebrew/cask-versions
  brew cask install homebrew/cask-versions/adoptopenjdk8
  fi
}

setup_go() {
  echo "-- setup_go"
  [[ $isLinux ]] && setup_go_linux
}

setup_cloud() {
  echo "-- setup_cloud"
  if [[ $isMacos ]]; then
    echo " Installing CF-CLI..."
    [[ $isMacos ]] && brew install cloudfoundry/tap/cf-cli
    echo " Installing Docker..."
    brew install docker
  fi
}

setup_python() {
  echo "-- setup_python"
  if [[ $isMacos ]]; then
    echo " Installing pipenv..."
    pip3 install pipenv
    pip3 install --upgrade jedi 
  fi
}
setup_clojure() {
  echo "-- setup_clojure"
  hasClj=$(command -v clj)
  hasLein=$(command -v lein)
  if [[ $isMacos ]]; then
    echo " Installing clojure..."
    [[ $hasClj ]] && brew upgrade clojure || brew install clojure
    echo " Installing lein..."
    [[ $hasLein ]] && brew upgrade leiningen|| brew install leiningen
  fi

}
setup_fzf() {
  echo "-- setup_fzf"
  if [[ $hasGit ]]; then
    [[ -d $trueHome/src ]] || mkdir -p $trueHome/src
    [[ -d $trueHome/src/fzf ]] || git -C $trueHome/src clone --depth 1 https://github.com/junegunn/fzf.git
    git -C $trueHome/src/fzf pull
    yes | $trueHome/src/fzf/install
  else
    echo "WARN: Cannot install fzf from source since git not found!"
  fi
}

setup_ctags() {
  echo "-- setup_ctags"
  if [[ $isMacos ]]; then
    # https://github.com/universal-ctags/homebrew-universal-ctags
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
  fi

  if [[ $isLinux ]]; then
    [[ -d ~/src ]] || mkdir -p ~/src
    git -C ~/src clone --depth 1 https://github.com/universal-ctags/ctags.git
    pushd ~/src/ctags
    ./autogen.sh
    ./configure
    make
    sudo make install
    popd
  fi
}

setup_ripgrep() {
  echo "-- setup_ripgrep"
	if [[ $isLinux ]]; then
		echo "(setup_ripgrep) Downloading ripgrep Linux release ..."
		pkg=$(gh_download_linux_release "BurntSushi" "ripgrep" "amd64")
		if [[ $? == 0 ]]; then
			echo "(setup_ripgrep) Downloaded as $pkg. Installing..."
			sudo dpkg -i $pkg
		fi
	fi
	if [[ $isMacos ]]; then
	  brew tap burntsushi/ripgrep https://github.com/BurntSushi/ripgrep.git
   	  brew install ripgrep-bin
	fi
}

setup_jq() {
  echo "-- setup_jq"
	if [[ $isLinux ]]; then
		echo "(setup_jq) Downloading jq Linux release ..."
		binary=$(gh_download_linux_release "stedolan" "jq" "linux64")
		if [[ $? == 0 ]]; then
			echo "(setup_jq) Downloaded as $binary. Installing..."
			chmod +x $binary
			sudo cp $binary /usr/local/bin/jq
		fi
	fi
	if [[ $isMacos == true ]]; then
		brew install jq
	fi
}

setup_fd() {
  echo "-- setup_fd"
	if [[ $isLinux ]]; then
		echo "(setup_fd) Downloading fd Linux release ..."
		pkg=$(gh_download_linux_release "sharkdp" "fd" 'fd_.*amd64.deb')
		if [[ $? == 0 ]]; then
			echo "(setup_fd) Downloaded as $pkg. Installing..."
			sudo dpkg -i $pkg
		fi
	fi
  [[ $isMacos ]] && brew install fd
}

setup_sed_awk_grep() {
  echo "-- setup_sed_awk_grep"
  export HOMEBREW_NO_AUTO_UPDATE=1
  if [[ $isMacos ]]; then
    local sedPath=$(which sed)
    [[ $sedPath == *"local"* ]] \
      && brew upgrade gnu-sed || brew install gnu-sed 
    local awkPath=$(which awk)
    [[ $sedPath == *"local"* ]] \
      && brew upgrade gawk || brew install gawk 
    local grepPath=$(which grep)
    [[ $grepPath == *"local"* ]] \
      && brew upgrade grep  || brew install grep
  fi
}



setup_rq() {
  echo "-- setup_rq"
}

setup_vim() {
  initialize_vars
  echo "-- setup_vim"
  export dotfilesVimCfgDir=$dotfilesDir/vimcfg
  local nvimConfigDir=$trueHome/.config/nvim
  echo "dotfilesVimCfgDir: $dotfilesVimCfgDir"
  echo "nvimConfigDir: $dotfilesVimCfgDir"

  rm $trueHome/.vimrc 2> /dev/null
  rm $trueHome/_vimrc 2> /dev/null
  rm $trueHome/.ideavimrc 2> /dev/null
  rm $nvimConfigDir/init.vim 2> /dev/null

  echo "nvimConfigDir :$nvimConfigDir"
  [[ -d  $nvimConfigDir ]] || mkdir -p $nvimConfigDir
  rm $trueHome/.config/nvim
  ln $dotfilesVimCfgDir/vimrc $trueHome/.vimrc
  ln $dotfilesVimCfgDir/ideavimrc $trueHome/.ideavimrc
  # Must fix this for windows, where it is ~/AppData/Local/nvim/init.vim
  ln $dotfilesVimCfgDir/init.vim $nvimConfigDir/init.vim 
  ln $dotfilesVimCfgDir/coc-settings.json $nvimConfigDir/coc-settings.json
  echo "Setup Dir $dotfilesSetupDir"

  curl -fLo $trueHome/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  if command -v pip3 >/dev/null 2>&1 ; then
    echo "Install python based module neovim-remote.."
    #pip3 install neovim --upgrade
    #pip3 install --user neovim-remote
  else
    echo "WARN: can't find pip3!"
  fi
  vim +PlugInstall +qall
}

setup_misc() {
  echo "- setup_misc"
}

setup_util() {
  echo "- setup_util"
  setup_ctags
  setup_fzf
  setup_ripgrep
  setup_jq
  setup_fd
  setup_sed_awk_grep
  #setup_rq
  #[[ $GOPATH ]] || export GOPATH=$trueHome
  #if ! command -v go >/dev/null 2>&1 ; then
  # export PATH=$PATH:/usr/local/go/bin
  #fi

  if command -v go >/dev/null 2>&1 ; then
    echo "Installing neosdkurls..."
    go get -v github.com/lenkite/mycliutil/neosdkurls
    echo "Installing pet..."
    go get -v github.com/knqyf263/pet
    echo "Installing delve..."
    go get -u github.com/derekparker/delve/cmd/dlv
    echo "Installing yolo..."
    go get github.com/azer/yolo
    echo "Installing zlook..."
    go get github.com/elankath/zlook/cmd/zlook
  else
    echo "WARNING: Go not found or not in PATH. Kindly correct so lovely utilities can be installed"
  fi

  ##See https://github.com/ratishphilip/nvmsharp
  #if [[ $isCygwin || $isWsl ]]; then
  #  local nvmsharpUrl="https://raw.githubusercontent.com/ratishphilip/nvmsharp/master/nvmsharp_executable.zip"
  #  if [[ $hasCurl && $hasUnzip ]]; then
  #    echo "Installing nvmsharp..."
  #    curl -L -C - $nvmsharpUrl -o /tmp/nvmsharp.zip
  #    rm -rf /tmp/nvmsharp_executable
  #    unzip /tmp/nvmsharp.zip -d /tmp
  #    [[ -d ~/bin ]] || mkdir ~/bin
  #    cp /tmp/nvmsharp_executable/* ~/bin
  #  fi
  #fi
}

setup_settings() {
  echo "- setup_settings"
  hasTmux=$(command -v tmux)
  if [[ $isMacos ]]; then
    [[ $hasTmux ]] && brew upgrade tmux || brew install tmux
  elif [[ $isLinux ]]; then
    [[ $hasTmux ]] || sudo -E apt-get --yes install tmux
  else
    echo "Don't know how to instal tmux for this OS"
  fi
  if [[ $isMacos ]]; then
    echo "Setting InitialKeyRepeaaat and KeyRepeat"
    defaults write -g KeyRepeat -int 1
    defaults write -g InitialKeyRepeat -int 12
  fi

  tmuxCfg=$trueHome/.tmux.conf
  [[ -f  $tmuxCfg ]] && rm $tmuxCfg
  echo "Linking $tmuxCfg to $dotfilesDir/tmux.conf ..."
  ln $dotfilesDir/tmux.conf $tmuxCfg

  sshCfg=$trueHome/.ssh/config 
  [[ -f $sshCfg ]] && rm $sshCfg
  echo "Linking $sshCfg to $dotfilesDir/sshcfg/config ..."
  ln $dotfilesDir/sshcfg/config $sshCfg

  # Setup lein profile
  [[ -d $trueHome/.lein ]] || mkdir -p $trueHome/.lein
  local leinCfg=$trueHome/.lein/profiles.clj
  echo "Linking lein profiles.clj to $leinCfg"
  [[ -f $leinCfg ]] && rm $leinCfg
  ln $dotfilesDir/leincfg/profiles.clj $leinCfg

}

setup_sdk() {
  echo "- setup_sdk"
  setup_jdk
  setup_maven
  # setup_go
  # setup_cloud
  # setup_python
  setup_clojure
}

setup_zsh() {
  initialize_vars
  echo "- setup_zsh"
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
      echo "Current shell is $SHELL. Changing to /bin/zsh. Please install zsh view 'brew install zsh' if not present."
      sudo chsh -s /bin/zsh
    else
      echo "Shell SWITCH for cygwin not implemented yet. Please add line 'db_shell: /bin/zsh' in /etc/nsswitch.conf"
    fi
  fi

  if [[ -d $trueHome/.zgen ]]; then
    echo "Removing old zgen stuff.."
    rm -rf $trueHome/.zgen
  fi

  # if [[ $hasCurl ]]; then
  #   echo "Installing antigen"
  #   local antigenDir=$trueHome/.antigen
  #   [[ -d $antigenDir ]] || mkdir -p $antigenDir
  #   local antigenLoc=$antigenDir/antigen.zsh
  #   [[ -f $antigenLoc ]] && rm -f $antigenLoc
  #   curl -L git.io/antigen > $antigenLoc
  # else
  #   echo "ERROR: Could not find git and hence couldn't clone zgen :("
  # fi

  if [ -d $trueHome/.zgen -a -d $trueHome/.zgen/.git ]; then
    git -C $trueHome/.zgen reset --hard
    git -C $trueHome/.zgen pull
  else
    git clone https://github.com/tarjoilija/zgen.git "${trueHome}/.zgen"
  fi

  # https://github.com/chriskempson/base16-shell
  echo "Installing base16-shell"
  [[ -d $trueHome/.config ]] || mkdir -p $trueHome/.config
  [[ -d $trueHome/.config/base16-shell ]] || git clone https://github.com/chriskempson/base16-shell.git $trueHome/.config/base16-shell
  git -C $trueHome/.config/base16-shell pull

  [[ -d $trueHome/src/dircolors-solarized ]] ||  git -C $trueHome/.config clone https://github.com/seebi/dircolors-solarized.git
  git -C $trueHome/.config/dircolors-solarized pull

  [[ -d $trueHome/src ]] || mkdir -p $trueHome/src
  [[ -d $trueHome/src/base16-shell ]] && git -C $trueHome/src clone 

  [[ -f $trueHome/.inputrc ]] || ln $trueHome/dotfiles/inputrc $trueHome/.inputrc
}


setup_code() {
  echo " - setup_code"
  # setup_vim
  # setup_vscode
  setup_intellij
}

setup_vscode() {
  echo "-- setup_vscode"
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

setup_intellij()  {
  echo "-- setup_intellij"
}


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && isSetupSourced=true

setup_main
