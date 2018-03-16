colorsFile=~/.config/dircolors-solarized/dircolors.256dark
hasDircolors=$(command -v dircolors)
[[ -f $colorsFile ]] && [[ $hasDircolors ]] && $eval `dircolors $colorsFile`

