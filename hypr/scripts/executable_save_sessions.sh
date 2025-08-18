#!/usr/bin/env bash

mkdir -p "$HOME/.config/hypr/sessions"
hyprctl -j clients >"$HOME/.config/hypr/sessions/clients.json"
