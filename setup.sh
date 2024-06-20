#!/bin/bash
# Setups up dotfiles for use on various OS'es.
# Supported OS'es are Windows/Cygwin, Windows/WSL, MacOS and Linux
# Dev Note: Some funcs here are duplicated in zshcfg/0.zsh. This is by design

set -euo pipefail # See https://bertvv.github.io/cheat-sheets/Bash.html
declare codeSetup golibsSetup pkgSetup miscSetup sdkSetup viSetup zshSetup settingsSetup utilSetup allSetup
declare done_detect_os done_set_uservars done_set_homevars
declare isCygwin isWsl isLinux
declare trueHome dotfilesDir

usage() {
	echo "Usage: $0 [-c] [-g] [-p] [-v] [-t] [-u] [-z]" 1>&2
	exit 1
}

# Use getopt for simple option parsing
# See https://stackoverflow.com/questions/16483119/example-of-how-to-use-getopts-in-bash
# See http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts "cmpsuvtz" opt; do
	case "${opt}" in
	c)
		codeSetup=true
		;;
	g)
		golibsSetup=true
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
shift $((OPTIND - 1))

[ $codeSetup ] || [ $golibsSetup ] || [ $pkgSetup ] || [ $miscSetup ] || [ $utilSetup ] || [ $viSetup ] || [ $zshSetup ] || [ $sdkSetup ] || [ $settingsSetup ] || allSetup=true

echo "codeSetup = $codeSetup, golibsSetup = $golibsSetup, sdkSetup = $sdkSetup, viSetup = $viSetup, miscSetup = $miscSetup, zshSetup = $zshSetup, utilSetup = $utilSetup, settingsSetup = $settingsSetup, allSetup=$allSetup"

setup_main() {
	initialize_vars

	if [[ $allSetup == true && $isWsl == true ]]; then
		replace_linux_home_shell
	fi

	if [[ -d $dotfilesDir ]]; then
		echo "Dotfiles dir already exists. Updating..."
		git -C $dotfilesDir pull
	else
		echo "Cloning dotfiles into $dotfilesDir"
		git clone https://github.com/lenkite/dotfiles $dotfilesDir
	fi

	echo "Dotfiles Dir: $dotfilesDir"

	[[ $allSetup || $pkgSetup ]] && install_pkgs
	[[ $allSetup || $zshSetup ]] && setup_zsh
	[[ $sdkSetup || $allSetup ]] && setup_sdk
	# [[ $golibsSetup || $allSetup ]] && setup_golibs
	[[ $utilSetup || $allSetup ]] && setup_util
	[[ $settingsSetup || $allSetup ]] && setup_settings
	[[ $allSetup || $miscSetup ]] && setup_misc
	[[ $codeSetup || $allSetup ]] && setup_code
	[[ $viSetup || $allSetup ]] && setup_vim

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
	uname=$(uname)
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
	[[ -f /etc/redhat-release ]] && export isRedhat=true
	export osreleaseFile=/proc/sys/kernel/osrelease
	echo "Checking $osreleaseFile (if present)"

	if [[ -f $osreleaseFile ]]; then
		osrelease=$(cat $osreleaseFile)
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
	local hasCurl hasZip hasUnzip hasGit hasGo

	hasCurl=$(command -v curl)
	hasZip=$(command -v zip)
	hasUnzip=$(command -v unzip)
	hasGit=$(command -v git)
#	hasGo=$(command -v go)
#	[[ $? -ge 0 ]] && hasCtags=false || hasCtags=true
	[[ hasCurl ]] || echo "WARN: 'curl' not found. Setup may be incomplete"
#	[[ hasCtags ]] || echo "WARN: 'ctags' not found or GNU version not installed"
	[[ hasZip ]] || echo "WARN: 'zip' not found. Setup may be incomplete"
	[[ hasUnzip ]] || echo "WARN: 'unzip' not found. Setup may be incomplete"
	[[ hasGit ]] || echo "WARN: 'git' not found. Setup may be incomplete and need to be rerun"

}

set_uservars() {
	linUser=$(whoami)
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
		wh=${wh/$'\r'/} # https://stackoverflow.com/questions/7800482/in-bash-how-do-i-replace-r-from-a-variable-that-exist-in-a-file-written-using
		winHome=${wh/\"/}
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
	local winWho=$(
		cd $sys32dir
		whoami.exe
	)
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
	[[ -f $downloadPath ]] || (echo "Could not download: $downloadUrl" && return 3)
	echo $downloadPath
	return $downloadResult
}

install_pkgs() {
	echo "- (install_pkgs) Installing packages..."
	if [[ $isMacos == true ]]; then
		brew install coreutils parallel iproute2mac gnu-sed gnu-tar grep gzip fd jq yq ctags the_silver_searcher fortune cowsay node go rlwrap yarn neovim skim cmake deno ripgrep delve kubectl krew kube-ps1 gardener/tap/gardenctl-v2 int128/kubelogin/kubelogin gardener/tap/gardenlogin openvpn lazygit k9s tree-sitter bottom gdu luarocks rectangle watch gh
		brew tap johanhaleby/kubetail && brew install kubetail
		brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono-nerd-font --cask font-symbols-only-nerd-font
		npm install -g browser-sync
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
		$(cd /tmp && curl -L https://rawgit.com/transcode-open/apt-cyg/master/apt-cyg -O)
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

#	if command -v pip3 >/dev/null 2>&1; then
#		echo "INSTALL python neovim modules using pip3..."
#		pip3 install --user --upgrade pynvim
#	else
#		echo "WARN: can't find pip3!"
#	fi

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

}

setup_go() {
	echo "-- setup_go"
	[[ $isLinux ]] && setup_go_linux
}

setup_python() {
	echo "-- setup_python"
	if [[ $isMacos ]]; then
		echo " Installing pipenv..."
		pip3 install pipenv
		pip3 install --upgrade jedi
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

setup_sshpass() {
	echo "-- setup_sshpass"
	brew tap esolitos/ipa
	brew install esolitos/ipa/sshpass
}

setup_rq() {
	echo "-- setup_rq"
}

setup_vim() {
	initialize_vars
	echo "-- setup_vim"

	local nvimConfigDotfiles=$dotfilesDir/nvimcfg

	local nvimConfig=$trueHome/.config/nvim
	local nvimShare=$trueHome/.local/share/nvim
	local nvimState=$trueHome/.local/state/nvim
	local nvimCache=$trueHome/.cache/nvim

	[[ -e "$trueHome/.vimrc" ]] && rm "$trueHome/.vimrc"
	[[ -e "$trueHome/_vimrc" ]] && rm "$trueHome/_vimrc"
	[[ -e "$trueHome/.ideavimrc" ]] && rm $trueHome/.ideavimrc

	echo "Linking ideavimrc"
	ln $dotfilesDir/ideavimrc $trueHome/.ideavimrc

	echo "Deleting (if present) $nvimConfig, $nvimShare, $nvimState, $nvimCache"
	[[ -d $nvimConfig ]] && echo "deleing $nvimConfig.." && rm -rf $nvimConfig
	[[ -d $nvimShare ]] && echo "deleing $nvimShare.." && rm -rf $nvimShare
	[[ -d $nvimState ]] && echo "deleing $nvimState.." && rm -rf $nvimState
	[[ -d $nvimCache ]] && echo "deleing $nvimCache.." && rm -rf $nvimCache

	echo "Installing Astronvim.."
	git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

	nvim --headless +"TSUpdate vimdoc" +"q"
	local userConfigDir="$trueHome/.config/astronvim/lua/user"
	if [[ -d "$userConfigDir" ]]; then
		git -C "$userConfigDir" pull
	else
		git clone https://github.com/lenkite/astronvim_config.git "$userConfigDir"
	fi
	echo "-- setup_vim mostly done. Launch neovim to continue further."
	# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
	#  if [[ -d $trueHome/.config/nvim/lua/custom ]]; then
	# 	git -C $trueHome/.config/nvim/lua/custom pull
	#  else
	#   git clone https://github.com/lenkite/nvchad_custom_config ~/.config/nvim/lua/custom
	#  fi
	# NVCHAD_EXAMPLE_CONFIG=n nvim --headless +"TSUpdate vimdoc" +"q"

}

setup_misc() {
	echo "- setup_misc"
}

setup_util() {
	echo "- setup_util"
	[[ -d $trueHome/.zfuncs ]] || mkdir $trueHome/.zfuncs # for completions installed by tools

	if command -v kubectl &>/dev/null; then
		echo "- setup_util: kubectl completion zsh > $trueHome/.zfuncs/_kubectl"
		kubectl completion zsh >$trueHome/.zfuncs/_kubectl
	fi

	if command -v gardenctl &>/dev/null; then
		echo "- setup_util: gardenctl completion zsh >  $trueHome/.zfuncs/_gardenctl"
		gardenctl completion zsh >$trueHome/.zfuncs/_gardenctl
	fi

	if command -v kubebuilder &>/dev/null; then
		echo "- setup_util: kubebuilder completion zsh >  $trueHome/.zfuncs/_kubebuilder"
		kubebuilder completion zsh >$trueHome/.zfuncs/_kubebuilder
	fi

	#coreutils_dir=$(brew --prefix coreutils)
	#if [[ -d $coreutils_dir ]]; then
	#  ln -fs $(which gbase64) ~/bin/base64 && ln -fs $(which gsed) ~/bin/sed && ln -fs $(which gtar) ~/bin/tar
	#fi
	#unset coreutils_dir

	hasDeno=$(command -v deno)
	if [[ $hasDeno ]]; then
		deno completions zsh >~/.zfuncs/_deno
	fi

}

setup_settings() {
	echo "- setup_settings (OS settings)"
	hasTmux=$(command -v tmux)
	if [[ $isMacos ]]; then
		[[ $hasTmux ]] && brew install tmux
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

	sshCfg=$trueHome/.ssh/config
	[[ -f $sshCfg ]] && rm $sshCfg
	echo "Linking $sshCfg to $dotfilesDir/sshcfg/config ..."
	ln $dotfilesDir/sshcfg/config $sshCfg

}

setup_sdk() {
	echo "- setup_sdk (TODO)"
}

setup_zsh() {
	initialize_vars
	echo "- setup_zsh"
	echo "Copying zsh history to /tmp..."
	cp $trueHome/.zsh_history /tmp
	echo "Deleting all existing .z* files from home directory.."
	[[ -f "$trueHome/.zshrc" ]] && rm $trueHome/.zshrc
	[[ -f "$trueHome/.zprofile" ]] && rm $trueHome/.zprofile 2>/dev/null
	[[ -f "$trueHome/.zshenv" ]] && rm $trueHome/.zshenv 2>/dev/null
	[[ -f "$trueHome/.zlogin" ]] && rm $trueHome/.zlogin 3>/dev/null
	[[ -f "$trueHome/.zlogout" ]] && rm $trueHome/.zlogout 2>/dev/null
	[[ -f "$trueHome/.zpreztorc" ]] && rm $trueHome/.zpreztorc 2>/dev/null
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

	if [ -d $trueHome/.zgen -a -d $trueHome/.zgen/.git ]; then
		git -C $trueHome/.zgen reset --hard
		git -C $trueHome/.zgen pull
	else
		git clone https://github.com/tarjoilija/zgen.git "${trueHome}/.zgen"
	fi
	echo "Coping back .zsh_history to $trueHome..."
	cp /tmp/.zsh_history $trueHome/

	echo "--setup_zsh is done"

}

setup_code() {
	echo " - setup_code"
	echo "TODO: not yet implemented"
	# setup_intellij
	# setup_vim
}

setup_intellij() {
	echo "-- setup_intellij"
}

setup_main
