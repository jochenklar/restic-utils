SHELL := /bin/bash
USER_ID := $(shell id -u)

LABELS = de.jochenklar.restic.store \
         de.jochenklar.restic.klarserver

.PHONY: all install reload print run

deploy: install reload

install:
	cp launchd.sh ~/.restic/launchd.sh
	for l in $(LABELS); do \
		cp $$l.plist ~/Library/LaunchAgents/$$l.plist; \
	done

reload:
	for l in $(LABELS); do \
		launchctl bootout gui/$(USER_ID) ~/Library/LaunchAgents/$$l.plist 2> /dev/null || true; \
		launchctl bootstrap gui/$(USER_ID) ~/Library/LaunchAgents/$$l.plist; \
	done

print:
	for l in $(LABELS); do \
		launchctl print gui/$(USER_ID)/$$l; \
	done

run:
	for l in $(LABELS); do \
		launchctl kickstart -k gui/$(USER_ID)/$$l; \
	done
