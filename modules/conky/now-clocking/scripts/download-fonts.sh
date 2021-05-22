#!/bin/bash

set -eu

total_downloaded=0

check_command() {
    local command="$1"
    if ! command -v "$command" >/dev/null; then
        echo "Command '$command' is required and was not installed." >&2
        exit 1
    fi
}

download_font() {
    local url_type="$1"
    local name="$2"
    local fc_name="$3"
    local url="$4"


    if fc-list | grep -q "$fc_name"; then
        echo "Font $(tput setaf 2)$name$(tput sgr0) is already installed."
        return 0
    fi

    case $url_type in
        fontmirror-otf)
            curl -H "Referer: https://www.fontmirror.com/gotham-book" -L "$url" -o "$name.otf"
            mv -i "$name.otf" "$fonts_dir"
            ;;
        ttf-zip)
            curl -L "$url" -o "download.zip"
            mkdir download
            unzip -d download download.zip
            mv download/*.ttf "$fonts_dir"
            rm -r download
            ;;
        *)
            echo "Unknown URL type: $url_type" >&2
            exit 1
            ;;
    esac

    echo "Installed font $(tput setaf 2)$name$(tput sgr0) successfully."
    total_downloaded=$(( total_downloaded + 1 ))
}

check_command curl
check_command unzip
check_command fc-list
check_command fc-cache

fonts_dir="$HOME/.local/share/fonts"
workdir="$(mktemp -d)"

mkdir -p "$fonts_dir"
cd "$workdir"

download_font fontmirror-otf "Gotham Book" "Gotham Book" "https://www.fontmirror.com/app_public/files/t/1/Gotham-Book_369762f0eb85426ad24f9a42322c0d9b.otf" "Gotham_Book"
download_font fontmirror-otf "Gotham Bold" "Gotham:style=Bold" "https://www.fontmirror.com/app_public/files/t/1/Gotham-Bold_0_7163aa8bf87d8495b8fa6fab4ae797c2.otf" "Gotham_Bold"
download_font ttf-zip "Montserrat" "Montserrat" "https://fonts.google.com/download?family=Montserrat"

if [[ $total_downloaded -gt 0 ]]; then
    echo -n "Reloading font cache... "
    fc-cache -f
    echo "$(tput bold)done$(tput sgr0)"
fi
