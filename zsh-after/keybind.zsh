# The behaviour of / and ? in command line is screwed up by prezto. I want to
# remove the incremental search keybindings 
# See
# http://unix.stackexchange.com/questions/285208/how-to-remove-a-zsh-keybinding-if-i-dont-know-what-it-does
# See man zshzle for these functions
bindkey -M vicmd "?" vi-history-search-forward
bindkey -M vicmd "/" vi-history-search-backward
