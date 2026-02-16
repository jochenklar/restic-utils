restic-utils
============

Bash scripts to simplify using [restic](https://restic.net) with multiple repositories
and for unattended backups. A bit like [autorestic](https://autorestic.vercel.app/), but less
sophisticated and using only `bash`.

Setup
-----

Run `bin/install` to add the bash functions `restic-env` and `restic-backup` to your `~/.bashrc`
and to create a `~/.restic` directory with several configuration files, which then need to be edited for:

1) `~/.restic/repositories` needs to contain a list of repositories like this:

    ```
    server=sftp:server:/tank/restic/
    ssd=/Volumes/ssd/restic/
    ```

2) `~/.restic/pass` needs to contain a the (common) passphrase for all those repositories:

3) `~/.restic/include` contains the local paths to be included in the backup (`--from-file`)

4) `~/.restic/exclude` contains the paths / files to be excluded from the backup (`--exclude-file`)

5) `~/.restic/recipients` optionally contains space separated mail addresses will receive a notification email

6) `~/.restic/run` optionally contains a file path on the remote which will be created and removed via `ssh`


Usage
-----

In a new shell, run `restic-env server` to source the environment variables for restic:

```bash
$ restic-env server
Setting RESTIC_REPOSITORY=sftp:server:/tank/restic
Setting RESTIC_PASSWORD_FILE=/Users/<user>/.restic/pass
```

Now, restic can be used without `-r` or passwords, e.g.:

```bash
restic init
restic snapshots
```

The backup itself can be invoked using:

```
restic-backup
```
