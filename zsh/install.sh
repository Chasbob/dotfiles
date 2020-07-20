SOURCE=$1
INSTALL_PLUGINS=$2

ZDOTDIR=$SOURCE/zsh
echo "Setup .zshenv..."
ln -sb "$ZDOTDIR"/.zshenv "$HOME"/.zshenv
if [ "$INSTALL_PLUGINS" = true ] ; then
  type zsh && zsh -ic "echo '**** installing zsh things ****" || echo "**** zsh not installed, skipping plugin installation ****"
fi
