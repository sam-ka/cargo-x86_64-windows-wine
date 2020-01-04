#!/bin/sh
#
# Copyright (C) 2020 Kutometa SPLC, Kuwait
# License: LGPLv3 
# www.ka.com.kw
#
# This file is responsible for making sure the cargo's environment 
# is correctly set up before running container args.
#
# This script is ran inside the container
#
# Curently it checks that 
#   * '/crate' is mounted
#   * cargo's cwd is '/crate'
#   * add proper target flag
#

set -eu

[ -d "/crate" ] || {
    echo "ERROR: Mount crate directory at /crate" 1>&2
    exit 1
}

cargocmd="$1"
shift
cd "/crate" && cargo "$cargocmd" "--target=x86_64-pc-windows-gnu" "$@"
