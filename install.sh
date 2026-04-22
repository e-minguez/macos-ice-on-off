#!/usr/bin/env bash
set -euo pipefail

REPO="eminguez/macos-ice-on-off"
BINARY_NAME="ice-monitor-toggle"
INSTALL_DIR="/usr/local/bin"
PLIST_NAME="com.jordanbaird.ice-monitor-toggle.plist"
PLIST_DST="$HOME/Library/LaunchAgents/$PLIST_NAME"

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  arm64)   ASSET="ice-monitor-toggle-arm64" ;;
  x86_64)  ASSET="ice-monitor-toggle-x86_64" ;;
  *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "Fetching latest release from GitHub..."
LATEST_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep "browser_download_url" \
  | grep "$ASSET" \
  | cut -d '"' -f 4)

if [[ -z "$LATEST_URL" ]]; then
  echo "Could not find release asset '$ASSET'. Check https://github.com/$REPO/releases"
  exit 1
fi

echo "Downloading $ASSET..."
curl -fsSL "$LATEST_URL" -o "/tmp/$BINARY_NAME"
chmod +x "/tmp/$BINARY_NAME"

echo "Installing binary to $INSTALL_DIR/$BINARY_NAME (may prompt for password)..."
sudo mv "/tmp/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"

echo "Installing LaunchAgent..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/$PLIST_NAME" -o "$PLIST_DST"

echo "Loading LaunchAgent..."
launchctl load -w "$PLIST_DST"

echo "Done. ice-monitor-toggle is running."
echo "Logs: /tmp/ice-monitor-toggle.log"
