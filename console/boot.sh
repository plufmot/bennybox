#!/bin/bash
[[ "$(tty)" == "/dev/tty1" ]] || exit 0

LOG=/home/benny/console/boot.log
echo "=== Boot $(date) ===" >> $LOG

clear
echo ""
echo "  ██████╗ ███████╗███╗   ██╗███╗   ██╗██╗   ██╗    ██████╗  ██████╗ ██╗  ██╗"
echo "  ██╔══██╗██╔════╝████╗  ██║████╗  ██║╚██╗ ██╔╝    ██╔══██╗██╔═══██╗╚██╗██╔╝"
echo "  ██████╔╝█████╗  ██╔██╗ ██║██╔██╗ ██║ ╚████╔╝     ██████╔╝██║   ██║ ╚███╔╝ "
echo "  ██╔══██╗██╔══╝  ██║╚██╗██║██║╚██╗██║  ╚██╔╝      ██╔══██╗██║   ██║ ██╔██╗ "
echo "  ██████╔╝███████╗██║ ╚████║██║ ╚████║   ██║       ██████╔╝╚██████╔╝██╔╝ ██╗"
echo "  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝       ╚═════╝  ╚═════╝ ╚═╝  ╚═╝"
echo ""
echo "  ┌─────────────────────────────────────────────────────────────────────────┐"
echo "  │                        BENNY BOX  v1.0                                 │"
echo "  └─────────────────────────────────────────────────────────────────────────┘"
echo ""

sleep 1

echo "  > Booting game systems..."
sleep 0.4
echo "  > Scanning controllers..."

GAME=$(python3 /home/benny/console/pick_game.py 2>>$LOG)

if [ -z "$GAME" ]; then
    echo ""
    echo "  [ERROR] Game selection failed. Check /home/benny/console/boot.log"
    sleep 5
    exit 1
fi

GAME_NAME="${GAME##*|}"
GAME_NAME="$(basename "$GAME_NAME" .exe)"

echo "  > Selected: $GAME_NAME"
echo "  > Generating world data..."
sleep 0.3
echo "  > Loading assets..."
sleep 0.3
echo "  > Firing up the fun engine..."
sleep 0.3
echo "  > All systems nominal. Launching..."
sleep 0.5

echo "$GAME" > /home/benny/console/selected_game
echo "Game selected: $GAME" >> $LOG

startx /home/benny/console/session.sh -- :0 vt1 >> $LOG 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    clear
    echo ""
    echo "  ╔══════════════════════════════════════════╗"
    echo "  ║              GAME CRASHED                ║"
    echo "  ╚══════════════════════════════════════════╝"
    echo ""
    echo "  Game: $GAME_NAME"
    echo "  Exit code: $EXIT_CODE"
    echo ""
    echo "  Last log entries:"
    echo "  ─────────────────"
    tail -10 $LOG | sed 's/^/  /'
    echo ""
    echo "  SSH in: ssh benny@bennybox.local"
    echo "  View full log: cat /home/benny/console/boot.log"
    echo ""
    echo "  Restarting in 10 seconds..."
    sleep 10
fi
