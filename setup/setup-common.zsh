#!/bin/zsh

function setup-zsh {
  rm ~/.zshrc 2> /dev/null
  rm ~/.zprofile 2> /dev/null
  rm ~/.zshenv 2> /dev/null
  rm ~/.zlogin 2> /dev/null
  rm ~/.zlogout 2> /dev/null
  rm ~/.zpreztorc 2> /dev/null

  if [[ -e $preztoDir ]]; then
    git -C $preztoDir submodule update --init --recursive
    git -C $preztoDir pull
  else
    git clone --recursive https://github.com/lenkite/prezto.git $preztoDir
  fi
  for rcfile in $preztoDir/runcoms/^README.md(.N); do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
  done
  if [[ $SHELL != "/bin/zsh" ]]; then
    echo "Current shell is $SHELL. Changing to /bin/zsh"
    chsh -s /bin/zsh
  fi
}

function setup-vim {
  rm ~/.vimrc 2> /dev/null
  rm ~/.ideavimrc 2> /dev/null
  ln $vimConfigDir/vimrc ~/.vimrc
  ln $vimConfigDir/ideavimrc ~/.ideavimrc
  echo "Setup Dir $dotfilesSetupDir"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
