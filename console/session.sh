#!/bin/bash
# Benny's Console - X Session
# Reads game selection written by boot.sh, launches via Wine + box64/box86

RUNNER_PATH=$(cat /home/benny/console/selected_game)
RUNNER="${RUNNER_PATH%%|*}"
GAME="${RUNNER_PATH##*|}"
GAME_DIR="$(dirname "$GAME")"

xset s off -dpms &
openbox &
sleep 1

# Run from game's own directory (GMS2 needs this for data.win)
cd "$GAME_DIR"
# eval handles multi-word runners like "box64 wine64"
eval $RUNNER '"$GAME"'
