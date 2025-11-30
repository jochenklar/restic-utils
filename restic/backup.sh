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

# create run file via ssh
ssh $(echo $RESTIC_REPOSITORY | cut -d':' -f2) -t "touch /tmp/poweroff/${RESTIC_HOST}_$USER" 2> /dev/null

echo "Running restic backup"
if [ "$USER" = "jochen" ]; then
    OUTPUT=$(
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
            --exclude-file=$HOME/.restic/exclude \
        | tee /dev/tty
    )
elif [ "$USER" = "backup" ]; then
    OUTPUT=$(
        caffeinate -s restic -r $RESTIC_REPOSITORY backup \
            $HOME/Backup \
            --exclude-file=$HOME/.restic/exclude \
        | tee /dev/tty
    )
else
    OUTPUT=$(
        caffeinate -s restic -r $RESTIC_REPOSITORY backup \
            $HOME/Documents \
            --exclude-file=$HOME/.restic/exclude \
        | tee /dev/tty
    )
fi

echo "Send notification mail"
if [ $? -eq 0 ]; then
    RECIPIENTS="admin@jochenklar.de"
    SUBJECT="🎉 Restic succeeded for user $USER"
else
    RECIPIENTS="admin@jochenklar.de mail@jochenklar.de"
    SUBJECT="🚨 Restic failed for user $USER"
fi

msmtp $RECIPIENTS <<EOF
Subject: $SUBJECT

$OUTPUT
EOF

echo "Running restic forget"
caffeinate -s restic -r $RESTIC_REPOSITORY forget --prune \
    --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 100

# remove run file via ssh
ssh $(echo $RESTIC_REPOSITORY | cut -d':' -f2) -t "rm /tmp/poweroff/${RESTIC_HOST}_$USER" 2> /dev/null
