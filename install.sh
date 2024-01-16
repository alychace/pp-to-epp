#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

DIR="/usr/local/bin"

if [ ! -d "$DIR" ]; then
  echo "$DIRECTORY does not exist..."
  echo "Creating $DIR"
  mkdir -p $DIR
fi

# Copy files
cp $PWD/pp-to-epp.service /etc/systemd/system/
cp $PWD/pp-to-epp /usr/local/bin

# Set permissions
chown root:root /usr/local/bin/pp-to-epp /etc/systemd/system/pp-to-epp.service
chmod 655 /usr/local/bin/pp-to-epp /etc/systemd/system/pp-to-epp.service
chmod +x /usr/local/bin/pp-to-epp

# Enable systemd service
systemctl enable --now pp-to-epp.service
