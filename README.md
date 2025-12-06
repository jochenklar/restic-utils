restic-utils
============

Personal [restic](https://restic.net) setup for unattended backups.

Setup
-----

1) Setup passphrase-less ssh kley authentication.

2) Run `make` in `restic` to create all files in `~/.restic`

3) Run `make` in `launchd` (needs sudo) to install `launchd` agents.

4) Create `.restic/pass` file containing the key to the restic repo.


Usage
-----

```
# source the enviroment
. ~/.restic/env

# use restic as usual
restic init
restic snapshots
...
```

`launchd` will automatically run backups as described in the `launchd/*.plist` files.
