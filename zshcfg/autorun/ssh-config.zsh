#!/bin/zsh

# https://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions
# https://github.com/wwalker/ssh-find-agent
# http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/
hasSshAgent=$(command -v ssh-agent)

sshidentPath=~/src/ssh-ident
if [[ $hasSshAgent && $hasGit ]]; then
  [[ -d ~/src ]] || mkdir ~/src
  [[ -d $sshidentPath ]] || git -C ~/src clone https://github.com/ccontavalli/ssh-ident.git
  alias ssh="~/src/ssh-ident/ssh-ident"
fi

# if [[ $hasSshAgent ]]; then
#   ssh-find-agent -a
#   if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval $(ssh-agent) > /dev/null
#     ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
#   fi
# fi
