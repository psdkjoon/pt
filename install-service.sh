#!/usr/bin/env bash
ROOT=$(pwd)
DIR="${ROOT##*/}"
DART=$(which dart)
if [ -z "$DART" ]; then
    echo "dart was not found in PATH"
    exit 1
fi
sudo tee /etc/systemd/system/$DIR-bot.service >/dev/null <<UNIT
[Unit]
Description=service runner for $DIR-bot
After=network.target

[Service]
Type=simple
User=$(id -un)
WorkingDirectory=$ROOT
ExecStart=$DART $ROOT/bin/$DIR.dart
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
read -p "Start now? [y/N] " start
if [[ "$start" =~ ^[Yy]$ ]]; then
    sudo systemctl start $DIR-bot
fi
read -p "Enable on boot? [y/N] " enable
if [[ "$enable" =~ ^[Yy]$ ]]; then
    sudo systemctl enable $DIR-bot
fi
