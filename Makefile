BINARY    := /usr/local/bin/ice-monitor-toggle
PLIST_SRC := com.jordanbaird.ice-monitor-toggle.plist
PLIST_DST := $(HOME)/Library/LaunchAgents/$(notdir $(PLIST_SRC))

.PHONY: install uninstall build

install: build $(PLIST_DST)
	launchctl load -w $(PLIST_DST)
	@echo "ice-monitor-toggle installed and running."

build: ice-toggle.swift
	swiftc ice-toggle.swift -o $(BINARY)

$(PLIST_DST): $(PLIST_SRC)
	cp $(PLIST_SRC) $(PLIST_DST)

uninstall:
	-launchctl unload $(PLIST_DST) 2>/dev/null
	rm -f $(BINARY) $(PLIST_DST)
	@echo "ice-monitor-toggle uninstalled."
