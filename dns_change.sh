#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 <domain controller IP address>"
  exit 1
fi

echo "Setting DNS to domain controller $1..."

# Add DNS server to /etc/resolv.conf
echo "nameserver $1" > /etc/resolv.conf

# Restart networking service
systemctl restart systemd-networkd

echo "Done."
