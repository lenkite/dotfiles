#!/bin/zsh

echo "Inside zero"
cdir=$(cd "$(dirname "$0")"; pwd)

main() {
  detect_running_os
  set_uservars
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
	winUser=$(get_windows_user)
}

main
