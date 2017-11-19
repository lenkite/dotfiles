typeset -gxU path PATH
if [[ -d $HOME/src/flutter/bin ]]; then
  path+=$HOME/src/flutter/bin
fi
if [[ -d $HOME/src/flutter/flutter/bin ]]; then
  path+=$HOME/src/flutter/flutter/bin
fi
export PATH
