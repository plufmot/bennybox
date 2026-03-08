#!/bin/bash
# Benny's Console - X Session
# Called by startx with the game selection as $1 (format: "runner|/path/to/game.exe")

RUNNER_PATH="$1"
RUNNER="${RUNNER_PATH%%|*}"
GAME="${RUNNER_PATH##*|}"
GAME_DIR="$(dirname "$GAME")"

# Disable screen blanking and DPMS
xset s off -dpms &

# Start openbox window manager
openbox &
sleep 1

# Launch the game from its own directory (GMS2 needs this for data.win)
cd "$GAME_DIR"
exec $RUNNER "$GAME"
