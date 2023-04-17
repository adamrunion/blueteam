#!/bin/bash

# Install SELinux packages
sudo apt update
sudo apt install selinux-basics selinux-policy-default auditd -y

# Reboot system to enable SELinux
sudo reboot

# Wait for system to come back up
while ! ping -c1 google.com &>/dev/null; do :; done

# Verify that SELinux is enabled
if sudo selinuxenabled && echo Enabled || echo Disabled; then
  # Configure SELinux to enforce its policies
  sudo selinux-activate

  # Set SELinux mode to enforcing
  sudo setenforce 1

  # Make SELinux mode change permanent
  sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/g' /etc/selinux/config

  echo "SELinux has been enabled and configured."
else
  echo "Failed to enable SELinux."
fi
