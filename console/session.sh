#!/bin/bash
# Benny's Console - X Session
# Reads game selection written by boot.sh, launches via Wine + box64/box86

RUNNER_PATH=$(cat /home/benny/console/selected_game)
RUNNER="${RUNNER_PATH%%|*}"
GAME="${RUNNER_PATH##*|}"
GAME_DIR="$(dirname "$GAME")"

xset s off -dpms &
openbox --config-file /home/benny/.config/openbox/rc.xml &
sleep 1

# Force 1080p (prevents tiny window on 4K TVs)
xrandr --output HDMI-1 --mode 1920x1080 2>/dev/null || xrandr --output HDMI-1 --auto

sleep 0.5
cd "$GAME_DIR"
$RUNNER "$GAME"
