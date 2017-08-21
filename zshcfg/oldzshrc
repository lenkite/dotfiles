setopt AUTOCD
setopt CD_ABLE_VARS
setopt PUSHD_IGNORE_DUPS AUTOPUSHD
setopt CORRECT
setopt EXTENDED_GLOB
setopt HASH_ALL


# http://dougblack.io/words/zsh-vi-mode.html
set -o vi
bindkey -v
export KEYTIMEOUT=1 # very important for lag killing.



# Autoloads
# http://www.refining-linux.org/archives/36/ZSH-Gem-1-Programmable-file-renaming/
autoload -U zmv
#autoload -U promptinit
#promptinit
#if [[ ! $OS = Windows* ]]; then
#    autoload -U compinit #Used for compdef function. See aliases
#    compinit
#fi

# http://superuser.com/questions/362227/how-to-change-the-title-of-the-mintty-window
# Change title of MinTTY to current dir
function settitle() {
    echo -ne "\033]2;"$1"\007"
}
function chpwd() {
    settitle $PWD
}

expl() {
	if [[ -z "$1" ]]; then
		explorer `cygpath -aw "."`
	else
		explorer `cygpath -aw "$1"`
	fi
}

spdf() {
    if [[ -z "$1" ]];then
        echo "Usage: spdf <pdfPath>"
    else
        pdfPath=`cygpath -aw  "$1"`
        "$progfiles86/SumatraPDF/SumatraPDF.exe" "$pdfPath" 
    fi
}

wdiff() {
    # C:\Program Files (x86)\WinMerge
    if [[ $# -lt 2 ]]; then
        echo "Usage: wdiff <file1> <file2>"
    else
        f1=`cygpath -aw  "$1"`
        f2=`cygpath -aw  "$2"`
        "$progfiles86/WinMerge/WinMergeU.exe" "$f1" "$f2"
    fi
}

scite() {
    if [[ -z "$1" ]];then
        echo "Usage: scite <filePath>"
    else
        fpath=`cygpath -aw "$1"`
        "$progfiles86/SciTE/SciTE.exe" "$fpath"
    fi
}

# Opens a file using sublime text
st() {
    if [[ -z "$1" ]]; then
        echo "Usage: st <filePath>"
    else
        fpath=`cygpath -aw "$1"`
        "$progfiles/Sublime Text 3/sublime_text.exe" "$fpath"
    fi
}

function proxyset() {
    export http_proxy="http://proxy.blrl.sap.corp:8080"
    export https_proxy=$http_proxy
    if [[ ! -z $http_proxy ]]; then
        echo "Proxy set to $http_proxy"
    fi
}

function proxyclear() {
    unset http_proxy
    unset https_proxy
}


export EDITOR='vim'
source $dotfiles/histenv
function gitenv-sap() {
    source $dotfiles/env/gitenv-sap
}
function gitenv-hub() {
   source $dotfiles/env/gitenv-hub
}
function gitenv-bbt() {
   source $dotfiles/env/gitenv-bbt
}

source $dotfiles/git.zsh


#bindkeys
bindkey ' ' magic-space

export SHELL='zsh'
export PS1='%~$ '




#Setup SSH Agent
#http://holdenweb.blogspot.in/2007/12/cygwin-ssh-agent-control.html
export SSH_AUTH_SOCK=/tmp/.ssh-socket

ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
# Exit status 2 means couldn't connect to ssh-agent; start one now
rm -rf /tmp/.ssh-*
ssh-agent -a $SSH_AUTH_SOCK >/tmp/.ssh-script
source /tmp/.ssh-script
echo $SSH_AGENT_PID >/tmp/.ssh-agent-pid
fi


function kill-agent {
pid=`cat /tmp/.ssh-agent-pid`
kill $pid
}

#Ok now load some zsh libraries if present
if [[ -d  $dotfiles/scripts/github/z ]]; then
    . $dotfiles/scripts/github/z/z.sh
fi
cd ~

# function abspath() {
#     if [ -d "$1" ]; then
#         ( cd "$1"; dirs -l +0 )
#     else
#         ( cd "$(dirname "$1")"; d=$(dirs -l +0); echo "${d%/}/${1##*/}" )
#     fi
# }
# function abspath() { 
# pushd . > /dev/null; 
# if [ -d "$1" ]; then cd "$1"; 
#     dirs -l +0; 
# else 
#     cd "`dirname \"$1\"`"; 
#     cur_dir=`dirs -l +0`; 
#     if [ "$cur_dir" == "/" ]; then
#         echo "$cur_dir`basename \"$1\"`"; 
#     else 
#         echo "$cur_dir/`basename \"$1\"`"; 
#     fi;
# fi; 
# popd > /dev/null; 
# }



# Add colors to osx terminal
# http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
# Currently use the theme:  Deluxive State
# https://github.com/Deluxive/osx-terminal-themes/blob/master/Deluxive%20State.terminal
if [[ $TERM_PROGRAM == "Apple_Terminal" ]]; then
    echo "Setting ls colors assuming dark themed terminal"
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced #for dark terminal
fi


### ZSH Completion and Module stuff
# from http://www.nparikh.org/notes/zshrc.txt

# compinit initializes various advanced completions for zsh
autoload -U compinit && compinit 
# zmv is a batch file rename tool; e.g. zmv '(*).text' '$1.txt'
autoload zmv

# -----------------------------------------------
# Set up zsh autocompletions
# -----------------------------------------------

# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# General completion technique
zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

source $dotfiles/osdetect.zsh
if [[ iswin ]]; then
    source $dotfiles/windows.zsh
elif [[ isosx ]]; then
    source $dotfiles/osx.zsh
elif [[ islinux ]]; then
    source $dotfiles/linux.zsh
else
    export OS=$OSTYPE
fi
if [ -f "$dotfiles/aliases" ]; then
   source "$dotfiles/aliases"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
