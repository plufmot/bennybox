#!/usr/bin/env python3
"""
Benny Box - Game Picker
- Controller button held at boot -> game selection menu
- No input -> boots straight into Benny's World
Outputs: "wine|/path/to/game.exe"
"""
import time
import subprocess

GAMES = [
    ("Benny's World",     "/home/benny/games/bennys_world/Benny's World.exe",           "wine"),
    ("Shadow Strike",     "/home/benny/games/shadow_strike/Shadow Strike.exe",          "wine"),
    ("Adventure of Leek", "/home/benny/games/adventure_of_leek/AdventureOfLeek.exe",    "wine"),
    ("Blue Boy",          "/home/benny/games/blue_boy/Blue Boy Bleeding Out 1.01.exe",  "wine"),
]

DEFAULT_GAME = GAMES[0]
menu_triggered = False

try:
    import evdev
    devices = [evdev.InputDevice(p) for p in evdev.list_devices()]
    gamepads = [d for d in devices if evdev.ecodes.EV_KEY in d.capabilities()]
    if gamepads:
        deadline = time.time() + 3
        while time.time() < deadline:
            for dev in gamepads:
                try:
                    event = dev.read_one()
                    if event and event.type == evdev.ecodes.EV_KEY and event.value == 1:
                        menu_triggered = True
                        break
                except Exception:
                    pass
            if menu_triggered:
                break
            time.sleep(0.05)
    else:
        menu_triggered = True
except Exception:
    menu_triggered = True

if menu_triggered:
    choices = []
    for i, (name, _, _) in enumerate(GAMES):
        choices += [str(i + 1), name]
    result = subprocess.run(
        ["whiptail", "--title", "Benny Box", "--menu",
         "Choose a game:", "15", "50", str(len(GAMES))] + choices,
        capture_output=True, text=True,
    )
    try:
        idx = int(result.stdout.strip()) - 1
        _, path, runner = GAMES[idx]
    except Exception:
        _, path, runner = DEFAULT_GAME
else:
    _, path, runner = DEFAULT_GAME

print(f"{runner}|{path}")
