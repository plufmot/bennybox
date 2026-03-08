#!/bin/bash
# Benny's Console - Boot Launcher
# Called from ~/.bash_profile on tty1
# Detects controller input, picks game, then starts X

[[ "$(tty)" == "/dev/tty1" ]] || exit 0

# Pick game (shows menu if controller button held at boot, else Benny's World)
GAME=$(python3 /home/benny/console/pick_game.py)

# Start X with the selected game as the session
exec startx /home/benny/console/session.sh "$GAME" -- :0 vt1
