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

function prefixOutput {
  prefix="$1"
  {
    shift
    eval $($@)
  } > >(sed "s/^/[$1]: /") 2> >(sed "s/^/[$1]: (stderr) /" >&2)
}

# components checker
function shouldInstall {
        set +x
	if [[ $COMPONENTS == all ]]; then
		return 0
	fi

	target=$1
	for i in $COMPONENTS; do
		if [[ $i == "$target" ]]; then
			return 0
		fi
	done

        set -x
	return 1
}

if shouldInstall zsh; then
	echo "Installing zsh..."
	prefixOutput "zsh" "$SOURCE"/zsh/install.sh "$SOURCE"
fi

if shouldInstall nvim; then
	echo "Installing nvim..."
	prefixOutput "nvim" "$SOURCE"/nvim/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall alacritty; then
    echo "Installing alacritty..."
    prefixOutput "alacritty" "$SOURCE"/alacritty/install.sh "$SOURCE" "$DESTINATION"
fi

if shouldInstall tmux; then
	echo "Installing tmux..."
	prefixOutput "tmux" "$SOURCE"/tmux/install.sh "$SOURCE"
fi

if shouldInstall asdf; then
	echo "Installing asdf..."
        prefixOutput "asdf" "$SOURCE"/asdf/install.sh "$SOURCE"
fi

echo "Done."
