#!/usr/bin/env bash

rm -f ~/.xmonad/xmonad.state

gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh

xsetroot -cursor_name left_ptr

exec xmonad
