#!/usr/bin/env bash

# install command line tools using https://brew.sh/

# Update to the latest version of homebrew
# -----------------------------------------
brew update

# GNU command line utilities
# -----------------------------------------
brew install coreutils \
parallel \
iproute2mac \
gnu-sed \
gnu-tar \
grep \
gzip \
zoxide

# search and parsing utilities
# -----------------------------------------
brew install fd \
jq \
yq \
ctags \
the_silver_searcher \
ripgrep \
rga \
poppler

# fortune-cookie-generator for some fun
# -----------------------------------------
brew install fortune \
cowsay

# language runtimes
# -----------------------------------------
brew install node \
go \
lua \
deno \
openjdk

# package managers
# -----------------------------------------
brew install yarn \
luarocks

# k8s command line utilities
# -----------------------------------------
brew install kubectl \
krew \
kube-ps1 \
k9s

# tail k8s logs with kubetail
# -----------------------------------------
brew tap johanhaleby/kubetail && brew install kubetail

# gardener utilities
# -----------------------------------------
brew install gardener/tap/gardenctl-v2 \
int128/kubelogin/kubelogin \
gardener/tap/gardenlogin 

# miscellaneous utilities
# -----------------------------------------
brew install rlwrap \
openvpn \
tree-sitter \ # parser generator tool
bottom \ # https://github.com/ClementTsang/bottom
rectangle \
watch \
make \
trash \
htop \
bat \
tmux \
derlin/bitdowntoc/bitdowntoc

# editors
# -----------------------------------------
brew install neovim
brew install --cask visual-studio-code

# pdf reader
# -----------------------------------------
brew install skim 

# git utilities
# -----------------------------------------
brew install lazygit \
gh \
diff-so-fancy # once this is installed git should be configured to use diff-so-fancy instead of vanilla diff.

# fonts
# ------------------------------------------

fonts_list=(
  font-3270-nerd-font
  font-fira-mono-nerd-font
  font-inconsolata-go-nerd-font
  font-inconsolata-lgc-nerd-font
  font-inconsolata-nerd-font
  font-monofur-nerd-font
  font-overpass-nerd-font
  font-ubuntu-mono-nerd-font
  font-agave-nerd-font
  font-arimo-nerd-font
  font-anonymice-nerd-font
  font-aurulent-sans-mono-nerd-font
  font-bigblue-terminal-nerd-font
  font-bitstream-vera-sans-mono-nerd-font
  font-blex-mono-nerd-font
  font-caskaydia-cove-nerd-font
  font-code-new-roman-nerd-font
  font-cousine-nerd-font
  font-daddy-time-mono-nerd-font
  font-dejavu-sans-mono-nerd-font
  font-droid-sans-mono-nerd-font
  font-fantasque-sans-mono-nerd-font
  font-fira-code-nerd-font
  font-go-mono-nerd-font
  font-gohufont-nerd-font
  font-hack-nerd-font
  font-hasklug-nerd-font
  font-heavy-data-nerd-font
  font-hurmit-nerd-font
  font-im-writing-nerd-font
  font-iosevka-nerd-font
  font-jetbrains-mono-nerd-font
  font-lekton-nerd-font
  font-liberation-nerd-font
  font-meslo-lg-nerd-font
  font-monoid-nerd-font
  font-mononoki-nerd-font
  font-mplus-nerd-font
  font-noto-nerd-font
  font-open-dyslexic-nerd-font
  font-profont-nerd-font
  font-proggy-clean-tt-nerd-font
  font-roboto-mono-nerd-font
  font-sauce-code-pro-nerd-font
  font-space-mono-nerd-font
  font-terminess-ttf-nerd-font
  font-tinos-nerd-font
  font-ubuntu-nerd-font
  font-victor-mono-nerd-font
)

for font in "${fonts_list[@]}"
do
  brew install --cask "$font"
done

# remove outdated versions
brew cleanup
