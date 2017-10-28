#!/bin/zsh

cdir=$(cd "$(dirname "$0")"; pwd)

main() {
  detect_running_os
  set_uservars
  if [[ "$isWsl" == true ]]; then
    start() {
      local target_path=$(wslpath -r -s -w $1)
      (cd /mnt/c && /mnt/c/Windows/explorer.exe $target_path)
    }
  elif [[ "$isMacos" == true ]]; then
    alias start=open
  else
    #TODO: how to handle this for pure linux
  fi
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

get_windows_user() {
	local sys32dir="/mnt/c/Windows/System32"
	local winWho=$(cd $sys32dir; whoami.exe)
	local winUser=${winWho##*\\}
	cd $cdir
	echo $winUser 
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


main
