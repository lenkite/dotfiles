#!/bin/zsh

if [[ -z "$GOPATH" ]]; then
  export GOPATH="$HOME"
else 
  export GOPATH="$HOME:$GOPATH"
fi
