#!/bin/bash

# argument parsing
SOURCE="$( cd "$(dirname "$0")" >/dev/null 2>&1 || . ; pwd -P )"
DESTINATION="$HOME/.config"
echo "SOURCE=$SOURCE"
while getopts "h:p:" flag; do
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

if shouldInstall zsh; then
	echo "Installing zsh..."
	"$SOURCE"/zsh/install.sh "$SOURCE"
fi

if shouldInstall nvim; then
	echo "Installing nvim..."
	"$SOURCE"/nvim/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall alacritty; then
    echo "Installing alacritty..."
    "$SOURCE"/alacritty/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall tmux; then
	echo "Installing tmux..."
	"$SOURCE"/tmux/install.sh "$SOURCE"
fi

echo "Done."