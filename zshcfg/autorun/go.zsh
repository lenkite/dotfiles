#!/bin/zsh

if [[ $isCygwin ]]; then
  export GOPATH=`cygpath -am ~`
else
  export GOPATH="$HOME"
fi

if [[ -d /usr/local/go/ ]]; then
  typeset -gxU path PATH
  export GOROOT=/usr/local/go
  path+=$GOROOT/bin
  export PATH
fi
