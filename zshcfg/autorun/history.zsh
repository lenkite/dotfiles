#Increase history size
## See http://zsh.sourceforge.net/Guide/zshguide02.html#l16

if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zhistory
fi
export HISTFILESIZE=10000000
export SAVEHIST=1000000
export HISTSIZE=1000000
setopt APPEND_HISTORY HIST_ALLOW_CLOBBER SHARE_HISTORY
setopt HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE HIST_VERIFY 


# The behaviour of / and ? in command line is screwed up by prezto. I want to
# remove the incremental search keybindings 
# See
# http://unix.stackexchange.com/questions/285208/how-to-remove-a-zsh-keybinding-if-i-dont-know-what-it-does
# See man zshzle for these functions
bindkey -M vicmd "?" vi-history-search-forward
bindkey -M vicmd "/" vi-history-search-backward

# http://dougblack.io/words/zsh-vi-mode.html
export KEYTIMEOUT=1

