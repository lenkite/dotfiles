typeset -gxU path PATH
neoweb=$HOME/sdk/neoweb
neoee=$HOME/sdk/neoee
if [[ -d $neoweb ]]; then
  path+=$neoweb/tools
fi
if [[ -d $neoee ]]; then
  path+=$neoee/tools
fi
export PATH
