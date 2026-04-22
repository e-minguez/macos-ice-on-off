# macos-ice-on-off

Automatically opens [Ice.app](https://github.com/jordanbaird/Ice) when no external monitor is connected, and quits it when one is plugged in.

Built as a lightweight Swift daemon using `CGDisplayRegisterReconfigurationCallback` — zero polling, 0% idle CPU, instant response.

## Requirements

- macOS 14+
- [Ice.app](https://github.com/jordanbaird/Ice) installed at `/Applications/Ice.app`

## Install (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/eminguez/macos-ice-on-off/main/install.sh | bash
```

This downloads the pre-built binary for your architecture (arm64 or x86_64), installs it to `/usr/local/bin`, and loads a LaunchAgent so it starts automatically on login.

## Install from source

Requires Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/eminguez/macos-ice-on-off
cd macos-ice-on-off
make install
```

## Uninstall

```bash
# If installed from source
make uninstall

# If installed via install.sh
launchctl unload ~/Library/LaunchAgents/com.jordanbaird.ice-monitor-toggle.plist
sudo rm /usr/local/bin/ice-monitor-toggle
rm ~/Library/LaunchAgents/com.jordanbaird.ice-monitor-toggle.plist
```

## How it works

A small Swift process registers a CoreGraphics display reconfiguration callback. When a monitor is connected or disconnected, macOS fires the callback immediately. The daemon then checks whether any non-built-in display is active (`CGDisplayIsBuiltin`) and opens or terminates Ice accordingly. A LaunchAgent keeps the daemon running across reboots.

## Logs

```bash
cat /tmp/ice-monitor-toggle.log
```
