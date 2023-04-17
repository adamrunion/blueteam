#!/bin/bash

# Install fail2ban
sudo apt-get update
sudo apt-get install fail2ban -y

# Backup the original configuration file
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configure fail2ban to block repeated failed login attempts
sudo sed -i 's/# bantime = 10m/bantime = 1h/g' /etc/fail2ban/jail.local
sudo sed -i 's/# findtime  = 10m/findtime  = 5m/g' /etc/fail2ban/jail.local
sudo sed -i 's/# maxretry = 5/maxretry = 3/g' /etc/fail2ban/jail.local

# Configure fail2ban to monitor ssh attempts
sudo sed -i 's/#\[sshd\]/\[sshd\]/g' /etc/fail2ban/jail.local
sudo sed -i '/\[sshd\]/a enabled = true' /etc/fail2ban/jail.local

# Restart fail2ban
sudo systemctl restart fail2ban
