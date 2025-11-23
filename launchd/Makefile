SHELL := /bin/bash
USER_ID := $(shell id -u)

LABELS = de.jochenklar.restic.klarserver.backup \
         de.jochenklar.restic.klarserver.jochen \
         de.jochenklar.restic.store.backup \
         de.jochenklar.restic.store.jochen \

.PHONY: all install enable reload print run

deploy: install enable reload

install:
	mkdir -p ~/.restic
	cp launchd.sh ~/.restic/launchd.sh
	for l in $(LABELS); do \
		sudo cp $$l.plist /Library/LaunchDaemons/$$l.plist; \
		sudo chown root:wheel /Library/LaunchDaemons/$$l.plist; \
		sudo chmod 644 /Library/LaunchDaemons/$$l.plist; \
	done

enable:
	for l in $(LABELS); do \
		sudo launchctl enable system/$$l; \
	done

reload:
	for l in $(LABELS); do \
		sudo launchctl bootout system /Library/LaunchDaemons/$$l.plist 2> /dev/null || true; \
		sudo launchctl bootstrap system /Library/LaunchDaemons/$$l.plist; \
	done

print:
	for l in $(LABELS); do \
		launchctl print system/$$l; \
	done

run:
	for l in $(LABELS); do \
		launchctl kickstart -k system/$$l; \
	done
