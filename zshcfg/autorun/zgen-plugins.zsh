if [[ -f ~/.zgen/zgen.zsh ]]; then
  if [[ $isCygwin ]]; then
    #zplug miekg/lean, use:prompt_lean_setup, from:github
  else 
    # zgen mafredri/zsh-async, from:github
    # zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
    zgen load supercrabtree/k
  fi
  #zgen prezto
  #zgen prezto utility
  zgen load zsh-users/zsh-syntax-highlighting
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh themes/arrow
  # zplug docker/cli, use:contrib/completion/zsh
  # zplug docker/compose, use:contrib/completion/zsh
  #[ $isMacos ] && zgen prezto homebrew
fi

# [ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh || return

# # Fancy stuff don't work in Cygwin
# if [[ $isCygwin ]]; then
#   zplug miekg/lean, use:prompt_lean_setup, from:github
# else 
#   zplug mafredri/zsh-async, from:github
#   zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
#   zplug supercrabtree/k
# fi
# zplug modules/utility, from:prezto
# zplug zsh-users/zsh-syntax-highlighting, defer:2
# zplug plugins/git, from:oh-my-zsh 
# zplug docker/cli, use:contrib/completion/zsh
# zplug docker/compose, use:contrib/completion/zsh
# [ $isMacos ] && zplug modules/homebrew, from:prezto


# # Check for uninstalled plugins.
# if ! zplug check --verbose; then
#   printf "Install? [y/N]: "
#   if read -q; then
#     echo; zplug install
#   fi
# fi

# zplug load 

