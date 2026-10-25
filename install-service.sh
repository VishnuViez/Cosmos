#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_FILE="$SCRIPT_DIR/cosmos-ui.service"

if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: cosmos-ui.service not found in $SCRIPT_DIR"
  exit 1
fi

echo "Installing Cosmos UI service..."
echo "Make sure you've edited cosmos-ui.service with your username and paths first!"
echo ""

sudo cp "$SERVICE_FILE" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable cosmos-ui
sudo systemctl start cosmos-ui
sudo systemctl status cosmos-ui
