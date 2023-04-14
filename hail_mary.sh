#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Setting the entire root directory as immutable..."

chattr -R +i /

echo "Done. To allow changes again, run this script again with the --allow-changes option."

if [[ "$1" == "--allow-changes" ]]; then
  echo "Allowing changes to the root directory..."

  chattr -R -i /

  echo "Done."
fi
