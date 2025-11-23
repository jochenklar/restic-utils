#!/bin/bash

# check if $1 is set correctly
if ! [[ "$1" == "store" || "$1" == "klarserver" ]]; then
    echo "ERROR: Unknown RESTIC_REPOSITORY: $1"
    exit 1
fi

REPOSITORY=$1
LABEL="de.jochenklar.restic.$REPOSITORY.$USER"

source $HOME/.restic/env $REPOSITORY
export PATH=/opt/homebrew/bin:$PATH

mkdir -p $HOME/Library/Logs/$LABEL

$HOME/.restic/backup.sh \
    >> $HOME/Library/Logs/$LABEL/std.out \
    2>> $HOME/Library/Logs/$LABEL/std.err
