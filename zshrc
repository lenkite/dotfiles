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


# Opens a file using sublime text
# FIXME: check in both program files and tools (if choco is being used)
wsubl() {
    if [[ -z "$1" ]]; then
        echo "Usage: subl <filePath>"
    else
        fpath=`cygpath -aw "$1"`
        "$progfiles/Sublime Text 3/sublime_text.exe" "$fpath"
    fi
}
