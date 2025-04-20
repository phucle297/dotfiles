#!/bin/bash

# Power menu using wofi
entries="Logout\nShutdown\nRestart\nSuspend"

selected=$(echo -e "$entries" | wofi --dmenu --prompt "Power Menu" --style ~/.config/wofi/style.css)

case "$selected" in
    "Logout")
        hyprctl dispatch exit;;
    "Shutdown")
        systemctl poweroff;;
    "Restart")
        systemctl reboot;;
    "Suspend")
        systemctl suspend;;
esac
