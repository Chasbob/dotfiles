#!/usr/bin/env bash

rm -f ~/.xmonad/xmonad.state

if [[ -e ~/.zshenv ]]; then
  source ~/.zshenv
fi

eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
# eval $(gnome-keyring-daemon --start)
# export GNOME_KEYRING_SOCKET
# export GNOME_KEYRING_PID


xsetroot -cursor_name left_ptr

exec xmonad
