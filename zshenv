# Purpose of zshenv:
# http://zsh.sourceforge.net/Intro/intro_3.html
# zshenv's are sourced on every shell

# lenkite's dotfiles zshenv does two things
#	* 	Sourcers ~/.env if present. ~/.env must contain lines of the form name=value
#		it exports corresponding environemnt variables. Ideally I would want this guy to also 
#		take care of setting these as windows environment variables by using a custom cygwin 
#		program that can invoke win32 api calls. But hey, atleast it works on *nix.
#	*	Looks for a ~/paths file that simply contains lines. Each line is tested to see if it
#		is a path that exists. If so it is added ot $PATH.


envfile=~/.env
if [[ -f $envfile ]]; then
	source $envfile
fi

# dirname $0 doesnt work for zshenv
if [[ -d ~/dotfiles ]]; then
	export dotfiles=~/dotfiles
fi

if [[ -d ~/dev/dotfiles ]]; then
	export dotfiles=~/dev/dotfiles
fi

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
