#!/usr/bin/env bash

LAYOUT_FILE="$HOME/.config/hypr/sessions/clients.json"

if [ ! -f "$LAYOUT_FILE" ]; then
  echo "❌ Layout file not found: $LAYOUT_FILE"
  exit 1
fi

# Define how to launch based on class (edit these to match your system)
launch_command_for_class() {
  case "$1" in
  kitty) echo "kitty --title \"$2\" &" ;;
  zen) echo "zen-browser &" ;; # Replace with your real launch command
  pulseUI) echo "/opt/pulsesecure/bin/pulseUI &" ;;
  firefox-developer-edition) echo "firefox-developer-edition &" ;;
  *) echo "" ;;
  esac
}

CURRENT_CLIENTS=$(hyprctl -j clients)
declare -A USED_ADDRS

# Count how many times each class has been opened
declare -A SPAWNED_COUNT

jq -c '.[]' "$LAYOUT_FILE" | while read -r saved; do
  saved_class=$(echo "$saved" | jq -r '.class')
  saved_title=$(echo "$saved" | jq -r '.title')
  saved_x=$(echo "$saved" | jq -r '.at[0]')
  saved_y=$(echo "$saved" | jq -r '.at[1]')
  saved_workspace=$(echo "$saved" | jq -r '.workspace.id')

  # Find all running clients of this class
  mapfile -t candidates < <(echo "$CURRENT_CLIENTS" | jq -r --arg c "$saved_class" '.[] | select(.class == $c) | .address')

  addr=""
  for candidate in "${candidates[@]}"; do
    if [[ -z "${USED_ADDRS[$candidate]}" ]]; then
      addr="$candidate"
      USED_ADDRS[$candidate]=1
      break
    fi
  done

  # If not found, spawn one
  if [ -z "$addr" ]; then
    echo "⏳ Launching $saved_class \"$saved_title\"..."

    # Get launch command and run
    launch_cmd=$(launch_command_for_class "$saved_class" "$saved_title")
    if [ -z "$launch_cmd" ]; then
      echo "⚠️  Unknown launch command for class: $saved_class"
      continue
    fi
    eval "$launch_cmd"

    # Wait up to 5s for the new window to appear
    for i in {1..50}; do
      sleep 0.1
      CURRENT_CLIENTS=$(hyprctl -j clients)
      addr=$(echo "$CURRENT_CLIENTS" | jq -r --arg c "$saved_class" '.[] | select(.class == $c) | .address' | grep -vF "${!USED_ADDRS[@]}" | head -n1)
      if [ -n "$addr" ]; then
        USED_ADDRS[$addr]=1
        break
      fi
    done

    if [ -z "$addr" ]; then
      echo "❌ Failed to launch or detect new window for $saved_class"
      continue
    fi
  fi

  echo "→ Restoring $saved_class to $saved_x,$saved_y on ws $saved_workspace"
  hyprctl dispatch focuswindow "address:$addr"
  sleep 0.1
  hyprctl dispatch movetoworkspace "$saved_workspace"
  sleep 0.05
  hyprctl dispatch movewindowpixel "exact $saved_x $saved_y"
done
