#!/bin/zsh

# https://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions
# https://github.com/wwalker/ssh-find-agent
# http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/
hasSshAgent=$(command -v ssh-agent)

# sshidentPath=~/src/ssh-ident
# if [[ $hasSshAgent && $hasGit ]]; then
#   [[ -d ~/src ]] || mkdir ~/src
#   [[ -d $sshidentPath ]] || git -C ~/src clone https://github.com/ccontavalli/ssh-ident.git
#   alias ssh="~/src/ssh-ident/ssh-ident"
# fi

if [[ $hasSshAgent ]]; then
	if [[ -d /tmp ]]; then
		SSH_ENV=/tmp/.sshenv
	fi
	function start_agent {
		echo "Initialising new SSH agent..."
		/usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
		chmod 600 ${SSH_ENV}
		. ${SSH_ENV} > /dev/null
		/usr/bin/ssh-add -t 28800 # identity lifetime 8 hours
	}

	# Source SSH settings, if applicable
	if [[ -f "${SSH_ENV}" ]]; then
		source ${SSH_ENV} > /dev/null
		#ps ${SSH_AGENT_PID} doesn't work under cywgin
		ps -efp ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || { start_agent; }
	else 
		start_agent;
	fi
else 
	echo "WARN: ssh-agent isn't available"
fi
# if [[ $hasSshAgent ]]; then
#   ssh-find-agent -a
#   if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval $(ssh-agent) > /dev/null
#     ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
#   fi
# fi
