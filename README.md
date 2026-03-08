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

## SSH access (for fixing things at events)

### Same WiFi network (home)
```bash
ssh benny@192.168.4.83
# or
ssh benny@bennybox.local
```
Password: `bennysworldrocksletsgo!`

### Direct ethernet (no WiFi — at events)
1. Plug an ethernet cable between your laptop and the Pi
2. Wait ~10 seconds for the link to come up
3. SSH using the hostname — no IP needed:
```bash
ssh benny@bennybox.local
```
This works because the Pi runs `avahi-daemon` (mDNS). Works on Mac, Linux, and Windows with Network Discovery enabled.

> **Tip:** If `bennybox.local` doesn't resolve, try `ping bennybox.local` first to force mDNS discovery, then SSH.

### Once in
The console will have started (or tried to start) X + the game. To get back to a shell you can work in:
```bash
# Stop X / the game
pkill xinit

# Or if something is broken and X never started, you're already at a shell
```

## Adding games

1. Add an entry to `console/pick_game.py` in the `GAMES` list
2. Push to GitHub
3. Pull on the Pi and rerun `setup/install.sh`
