#!/bin/bash

ASDF_DIR=${ASDF_DIR:-$HOME/.config/asdf}

echo "Load asdf"
[ ! -d "$ASDF_DIR" ] && git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"

