#!/bin/bash

# argument parsing
SOURCE="$( cd "$(dirname "$0")" >/dev/null 2>&1 || . ; pwd -P )"
DESTINATION="$HOME/.config"
INSTALL_PLUGINS=${INSTALL_PLUGINS:-false}
while getopts "h:p:i:" flag; do
	case $flag in
	h)
		echo "Usage: $0 [-p path] [components]"
		exit 1
		;;
	p)
		DESTINATION="$OPTARG"
		;;
    *)
		echo "Usage: $0 [-p path] [components]"
		exit 1
		;;
	esac
done
shift $(( OPTIND - 1 ))

# rest of arguments are components
if [[ $# -ge 1 ]]; then
	COMPONENTS=$@
else
	COMPONENTS=all
fi

function prefixOutput {
  prefix="$1"
  {
    shift
    echo "Installing..."
    bash $@
  } > >(sed "s/^/[$1]: /") 2> >(sed "s/^/[$1]: (stderr) /" >&2)
}

# components checker
function shouldInstall {
	if [[ $COMPONENTS == all ]]; then
		return 0
	fi

	target=$1
	for i in $COMPONENTS; do
		if [[ $i == "$target" ]]; then
			return 0
		fi
	done
	return 1
}

if shouldInstall gnugp; then
    prefixOutput "gnugp" "$SOURCE"/gnupg/install.sh "$DESTINATION"
fi

if shouldInstall git; then
    prefixOutput "git" "$SOURCE"/git/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall zsh; then
    prefixOutput "zsh" "$SOURCE"/zsh/install.sh "$SOURCE" "$INSTALL_PLUGINS"
fi

if shouldInstall spacevim; then
    # disabling INSTALL_PLUGINS for now
    prefixOutput "SpaceVim" "$SOURCE"/SpaceVim/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall alacritty; then
    prefixOutput "alacritty" "$SOURCE"/alacritty/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall tmux; then
    prefixOutput "tmux" "$SOURCE"/tmux/install.sh "$SOURCE"
fi

echo "**** DONE ****"
