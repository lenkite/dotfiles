#Increase history size
## See http://zsh.sourceforge.net/Guide/zshguide02.html#l16
export HISTFILESIZE=100000
export SAVEHIST=100000
export HISTSIZE=100000
setopt HIST_ALLOW_CLOBBER HIST_REDUCE_BLANKS

# The behaviour of / and ? in command line is screwed up by prezto. I want to
# remove the incremental search keybindings 
# See
# http://unix.stackexchange.com/questions/285208/how-to-remove-a-zsh-keybinding-if-i-dont-know-what-it-does
# See man zshzle for these functions
bindkey -M vicmd "?" vi-history-search-forward
bindkey -M vicmd "/" vi-history-search-backward

# http://dougblack.io/words/zsh-vi-mode.html
export KEYTIMEOUT=1

