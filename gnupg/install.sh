#!/bin/bash

DESTINATION=$1

echo "creating $DESTINATION/gnupg..."
mkdir -p "$DESTINATION/gnupg"
echo "setting permissions..."
chmod 0700 "$DESTINATION/gnupg"
