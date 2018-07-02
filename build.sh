#!/bin/bash

set -e
set -x

GETTEXT_PATH="$(brew --prefix gettext)"/bin
BISON_PATH="$(brew --prefix bison)"/bin
export PATH="${BISON_PATH}":"${GETTEXT_PATH}":"${PATH}"

if [[ $1 == --NUM_CORES=* ]]; then
    NUM_CORES=$(echo $1 | cut -d= -f2)
    shift 1
else
    NUM_CORES=$(sysctl -n hw.ncpu)
fi

mkdir -p build
cd build

cmake -DMACOS_MIN_VERSION="$(sw_vers -productVersion | cut -d. -f1-2)" ../kicad-mac-builder

if [ -e kicad-dest ]; then
    echo "Cleaning out build/kicad-dest"
    rm -r kicad-dest
fi

if [ "$#" -eq 0 ]; then 
    make -j"${NUM_CORES}" package-kicad-unified package-kicad-nightly package-extras
else
    make -j"${NUM_CORES}" "$@"
fi
echo "build succeeded."
