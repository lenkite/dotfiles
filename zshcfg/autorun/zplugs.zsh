[ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh || return

# For non Cygwin platforms load the pure prompt and its deps
if [[ -z $isCygwin ]]; then
  zplug mafredri/zsh-async, from:github
  zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
  zplug supercrabtree/k
fi
zplug modules/utility, from:prezto
zplug zsh-users/zsh-syntax-highlighting, defer:2
zplug plugins/git, from:oh-my-zsh 
zplug changyuheng/zsh-interactive-cd
zplug docker/cli, use:contrib/completion/zsh
zplug docker/compose, use:contrib/completion/zsh
zplug RobSis/zsh-completion-generator
[ $isMacos ] && zplug modules/homebrew, from:prezto


# Check for uninstalled plugins.
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load 

