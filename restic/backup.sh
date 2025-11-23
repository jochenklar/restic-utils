#!/bin/bash

# check if $RESTIC_REPOSITORY is set
if [[ -z "$RESTIC_REPOSITORY" ]]; then
    echo "ERROR: RESTIC_REPOSITORY is not set"
    exit 1
fi

# check if the repo is available
restic snapshots list >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Repository $RESTIC_REPOSITORY is available."
    echo
else
    echo "Repository $RESTIC_REPOSITORY is not available. Skipping."
    exit 1
fi

echo "Running restic backup"
caffeinate -s restic -r $RESTIC_REPOSITORY backup \
    $HOME/.bashrc \
    $HOME/.bashrc.d \
    $HOME/.password-store \
    $HOME/.ssh \
    $HOME/code \
    $HOME/Documents \
    $HOME/Library/Thunderbird \
    $HOME/Pictures \
    $HOME/readme \
    $HOME/utils \
    --exclude-file=$HOME/.restic/exclude

sleep 1

echo "Running restic forget"
caffeinate -s restic -r $RESTIC_REPOSITORY forget \
    --prune \
    --keep-daily 7 \
    --keep-weekly 5 \
    --keep-monthly 12 \
    --keep-yearly 100
