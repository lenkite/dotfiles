#!/bin/zsh

if [[ $isCygwin ]]; then
  export GOPATH=`cygpath -am ~`
else
  export GOPATH="$HOME"
fi
