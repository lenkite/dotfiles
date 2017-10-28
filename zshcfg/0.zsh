#!/bin/zsh

cdir=$(cd "$(dirname "$0")"; pwd)

main() {
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

  source_env
  read_export_paths
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



source_env() {
  #Sourcers ~/.env if present. ~/.env must contain lines of the form name=value
  #it exports corresponding environemnt variables. Ideally I would want this guy to also 
  #take care of setting these as windows environment variables by using a custom cygwin 
  #program that can invoke win32 api calls. But hey, atleast it works on *nix.
  #Looks for a ~/paths file that simply contains lines. Each line is tested to see if it
  #is a path that exists. If so it is added ot $PATH.

  envfile=~/.env
  if [[ -f $envfile ]]; then
    source $envfile
  fi

  # dirname $0 doesnt work for zshenv
  if [[ -d ~/dotfiles ]]; then
    export dotfiles=~/dotfiles
  fi
}

read_export_paths() {
  # http://zsh.sourceforge.net/Guide/zshguide02.html#l24
  typeset -U path
  path+=( $dotfiles/scripts ~/bin )
  pathsf=~/.paths
  if [[ -f $pathsf ]]; then
    #http://stackoverflow.com/questions/12651355/zsh-read-lines-from-file-into-array
    zmodload zsh/mapfile
    FLINES=( "${(f)mapfile[$pathsf]}" )
    LIST="${mapfile[$pathsf]}" # Not required unless stuff uses it
    integer POS=1             # Not required unless stuff uses it
    integer SIZE=$#FLINES     # Number of lines, not required unless stuff uses it
    # setting path list sets PATH in zsh
    path+=( $FLINES )
    # echo $SIZE
    # for ITEM in $FLINES; do
    # 	echo $ITEM
    #     (( POS++ ))
    # done
  fi
}

main
