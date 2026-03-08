# Benny's Console (bennybox)

A Raspberry Pi 4 configured as a dedicated game console that boots directly into **Benny's World**.

## Games

| Game | Arch | Runner |
|------|------|--------|
| Benny's World | x86_64 | box64 |
| Shadow Strike | x86_64 | box64 |
| Adventure of Leek | x86_64 | box64 |
| Blue Boy | x86 | box86 |

## How it works

1. Pi boots → auto-login as `benny` on tty1
2. `.bash_profile` runs `console/boot.sh`
3. `boot.sh` runs `pick_game.py` — waits 3 seconds for a controller button press
   - **No button pressed** → launches Benny's World immediately
   - **Any button pressed** → shows game selection menu (whiptail)
4. Selected game starts fullscreen via `startx` + openbox + box64/box86

## Hardware

- Raspberry Pi 4 (8GB)
- Xbox controller (USB) and/or SNES USB controller
- HDMI to TV

## Setup

On a fresh **Raspberry Pi OS Lite 64-bit** (Debian Trixie), create user `benny`:

```bash
git clone https://github.com/BennyMctilderson/bennybox
cd bennybox
bash setup/install.sh
```

Then copy game zips to `/home/benny/games/` and unzip them:

```bash
unzip bennys_world.zip -d /home/benny/games/bennys_world/
unzip shadow_strike.zip -d /home/benny/games/shadow_strike/
unzip adventure_of_leek.zip -d /home/benny/games/adventure_of_leek/
unzip blue_boy.zip -d /home/benny/games/blue_boy/
```

Reboot — the console starts automatically.

## Adding games

1. Add an entry to `console/pick_game.py` in the `GAMES` list
2. Push to GitHub
3. Pull on the Pi and rerun `setup/install.sh`
