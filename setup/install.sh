#!/bin/bash
# Benny's Console - Setup Script
# Run on a fresh Raspberry Pi OS Lite 64-bit (Debian Trixie)
# as user: benny

set -e

echo "=== Benny's Console Setup ==="

# 1. Force IPv4 for apt (avoids IPv6-only DNS issues)
echo 'Acquire::ForceIPv4 true;' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# 2. Add Box86/Box64 repos
if [ ! -f /etc/apt/sources.list.d/box64.list ]; then
    sudo dpkg --add-architecture armhf
    sudo wget -qO /tmp/box64-key.gpg https://pi-apps-coders.github.io/box64-debs/KEY.gpg
    sudo gpg --no-tty --batch --yes --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg /tmp/box64-key.gpg
    sudo wget -qO /tmp/box86-key.gpg https://pi-apps-coders.github.io/box86-debs/KEY.gpg
    sudo gpg --no-tty --batch --yes --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg /tmp/box86-key.gpg
    echo 'deb [arch=arm64 signed-by=/usr/share/keyrings/box64-archive-keyring.gpg] https://Pi-Apps-Coders.github.io/box64-debs/debian ./' | sudo tee /etc/apt/sources.list.d/box64.list
    echo 'deb [arch=armhf signed-by=/usr/share/keyrings/box86-archive-keyring.gpg] https://Pi-Apps-Coders.github.io/box86-debs/debian ./' | sudo tee /etc/apt/sources.list.d/box86.list
fi

# 3. Install dependencies
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    box64-rpi4arm64 \
    box86-rpi4arm64 \
    python3-evdev \
    xserver-xorg \
    xinit \
    openbox \
    unzip \
    whiptail \
    xdotool \
    scrot \
    mesa-vulkan-drivers \
    vulkan-tools \
    libvulkan1

# 4. Set DNS to 1.1.1.1 (avoid Pi-hole IPv6-only issues)
CONN=$(nmcli -t -f NAME,DEVICE con show --active | grep -v lo | head -1 | cut -d: -f1)
if [ -n "$CONN" ]; then
    sudo nmcli con mod "$CONN" ipv4.dns "1.1.1.1 8.8.8.8" ipv4.ignore-auto-dns yes
    sudo nmcli con up "$CONN"
fi

# 5. Install console scripts
mkdir -p /home/benny/console /home/benny/games
cp console/boot.sh console/session.sh console/pick_game.py /home/benny/console/
chmod +x /home/benny/console/*.sh /home/benny/console/*.py

# 5a. Install Wine-9.17 (Pi-Apps tarball, x86_64 via box64)
# Download from: https://github.com/Botspot/pi-apps-coders/releases
# Extract to /opt/wine/wine-9.17 and install the wine-piapps wrapper
sudo mkdir -p /opt/wine
# After extracting wine tarball to /opt/wine/wine-9.17, install wrapper:
sudo cp setup/wine-piapps /usr/local/bin/wine-piapps
sudo chmod +x /usr/local/bin/wine-piapps

# 6. Set up auto-login on tty1
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo cp setup/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf
sudo systemctl daemon-reload
sudo systemctl enable getty@tty1

# 7. Set up .bash_profile
cp setup/bash_profile /home/benny/.bash_profile

echo ""
echo "=== Setup complete! ==="
echo "Copy your game zips to /home/benny/games/ and unzip them."
echo "Reboot to launch into Benny's Console."
