#!/bin/bash

# This script runs in the background to periodically save the Hyprland session.

SAVE_SCRIPT_PATH="$HOME/.config/hypr/scripts/executable_save_sessions.sh"
INTERVAL=300 # Save every 300 seconds (5 minutes)

while true; do
  bash "$SAVE_SCRIPT_PATH"
  sleep "$INTERVAL"
done
