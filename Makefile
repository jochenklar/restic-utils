.PHONY: install restic launchd

install: restic launchd

restic:
	$(MAKE) -C restic

launchd:
	$(MAKE) -C launchd
