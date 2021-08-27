#!/bin/bash

set -ex

cd "$(dirname "$0")"

conky -q -c ./conky/np.lua -d &>/dev/null
conky -q -c ./conky/npart.lua -d &> /dev/null
