#!/bin/zsh

git-pull-subdirs() {
branch=$1
if [[ ! -z $branch ]]; then
  echo "Will git pull sub-directories for branch $branch" 
else
  echo "Will git pull sub-directories at current branch"
fi
for d in */ ; do
  echo "Changing to directory $d"
  cd "$d"
  if [ -d ".git" ]; then
    echo "Git pulling $d ..."
    git pull
    if [[ ! -z $branch ]]; then
      echo "Changing branch to $branch"
      git checkout $branch
      git pull
    fi
  fi
  cd ..
  echo "$d"
done
}

if [[ $hasGit ]]; then
  git config --global credential.helper "cache --timeout=3600"  
  git config --global credential.https://github.com/lenkite.lenkite lenkite 
fi
export VISUAL=vim
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
