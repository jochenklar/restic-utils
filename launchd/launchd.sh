#!/bin/bash

# check if $1 is set correctly
if ! [[ "$1" == "store" || "$1" == "klarserver" ]]; then
    echo "ERROR: Unknown RESTIC_REPOSITORY: $1"
    exit 1
fi

source $HOME/.restic/env $1
export PATH=/opt/homebrew/bin:$PATH

mkdir -p $HOME/Library/Logs/de.jochenklar.restic.$1

$HOME/.restic/backup.sh \
    >> $HOME/Library/Logs/de.jochenklar.restic.$1/std.out \
    2>> $HOME/Library/Logs/de.jochenklar.restic.$1/std.err
