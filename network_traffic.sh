#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Capturing network traffic. Press Ctrl+C to stop."

tcpdump -i any -n -v

echo "Done."
