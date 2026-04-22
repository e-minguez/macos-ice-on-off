BINARY    := $(HOME)/.local/bin/ice-monitor-toggle
PLIST_SRC := com.jordanbaird.ice-monitor-toggle.plist
PLIST_DST := $(HOME)/Library/LaunchAgents/$(notdir $(PLIST_SRC))

.PHONY: install uninstall build

install: build
	mkdir -p $(HOME)/Library/LaunchAgents
	sed 's|BINARY_PATH_PLACEHOLDER|$(BINARY)|' $(PLIST_SRC) > $(PLIST_DST)
	launchctl load -w $(PLIST_DST)
	@echo "ice-monitor-toggle installed and running."

build:
	mkdir -p $(HOME)/.local/bin
	swiftc ice-toggle.swift -o $(BINARY)

uninstall:
	-launchctl unload $(PLIST_DST) 2>/dev/null
	rm -f $(BINARY) $(PLIST_DST)
	@echo "ice-monitor-toggle uninstalled."
