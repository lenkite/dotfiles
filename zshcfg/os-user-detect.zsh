# vim: set ft=zsh:

detect_os() {
  uname=`uname`
  if [[ $uname == 'Darwin' ]]; then
    export isMacos=true
  elif [[ $uname == 'Linux' ]]; then
    export isLinux=true
  elif [[ $uname == CYGWIN* ]]; then
    export isCygwin=true
  else
    echo "This Setup Script only works for Windows Cygwin, Windows Subsystem for Linux and MacOS"
    exit -1
  fi
  export osreleaseFile=/proc/sys/kernel/osrelease
  if [[ -f  $osreleaseFile ]]; then
    osrelease=`cat $osreleaseFile`
    if [[ $osrelease == *Microsoft* ]]; then
      export isWsl=true
    fi
  fi
}

get_windows_user() {
	local sys32dir="/mnt/c/Windows/System32"
	local winWho=$(cd $sys32dir; whoami.exe)
	local winUser=${winWho##*\\}
}

detect_user() {
  linUser=`whoami`
  if [[ $isCygwin == true ]]; then
    winUser=$linUser
  fi

  if [[ $isWsl == true ]]; then
    winUser=$(get_windows_user)
  fi
}


