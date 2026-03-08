# Boot Screen — Fantasy Console Design

When the Pi powers on, instead of showing a plain Linux login, Benny's Console displays a custom boot sequence in the terminal before launching the game.

## What you see

```
  ██████╗ ███████╗███╗   ██╗███╗   ██╗██╗   ██╗
  ██╔══██╗██╔════╝████╗  ██║████╗  ██║╚██╗ ██╔╝
  ██████╔╝█████╗  ██╔██╗ ██║██╔██╗ ██║ ╚████╔╝
  ██╔══██╗██╔══╝  ██║╚██╗██║██║╚██╗██║  ╚██╔╝
  ██████╔╝███████╗██║ ╚████║██║ ╚████║   ██║
  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝

  ██████╗ ██████╗ ██╗  ██╗
  ██╔══██╗██╔══██╗╚██╗██╔╝
  ██████╔╝██████╔╝ ╚███╔╝
  ██╔══██╗██╔═══╝  ██╔██╗
  ██████╔╝██║     ██╔╝ ██╗
  ╚═════╝ ╚═╝     ╚═╝  ╚═╝

  ┌─────────────────────────────────────────┐
  │         BENNY'S CONSOLE  v1.0           │
  └─────────────────────────────────────────┘

  > Booting game systems...
  > Scanning controllers...
  > Selected: Benny's World
  > Generating world data...
  > Loading assets...
  > Firing up the fun engine...
  > All systems nominal. Launching...
```

Then X starts and the game launches fullscreen.

## If the game crashes

Instead of a blank screen or silent restart loop, you'll see:

```
  ╔══════════════════════════════════════════╗
  ║              GAME CRASHED                ║
  ╚══════════════════════════════════════════╝

  Game: Benny's World
  Exit code: 1

  Last log entries:
  ─────────────────
  [error output here]

  SSH in: ssh benny@bennybox.local
  View full log: cat /home/benny/console/boot.log

  Restarting in 10 seconds...
```

This tells you exactly what went wrong and how to SSH in to fix it.

## Editing the boot text

The boot screen is in `console/boot.sh`. The flavour lines like `> Generating world data...` are just `echo` statements — edit them freely to change the vibe.

To add game-specific flavour text (different messages per game), you could match on `$GAME_NAME`:

```bash
case "$GAME_NAME" in
    "Benny's World")
        echo "  > Summoning Benny..."
        echo "  > Inflating the world balloon..."
        ;;
    "Shadow Strike")
        echo "  > Sharpening swords..."
        echo "  > Plotting enemy spawn points..."
        ;;
esac
```
