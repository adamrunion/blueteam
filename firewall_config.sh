#!/bin/bash

# This script will flush all existing rules to ensure that we are starting with a clean slate and prompt the user for a list of IPs that need to be whitelisted. 

# Flush all existing rules
iptables -F

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow established and related traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT

# Prompt for IP addresses to allow
echo "Enter IP addresses to allow (one per line), then press CTRL+D when finished:"
allowed_ips=()
while read -r ip; do
  if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    allowed_ips+=("$ip")
  fi
done

# Allow traffic from specified IP addresses
for ip in "${allowed_ips[@]}"; do
  iptables -A INPUT -s "$ip" -j ACCEPT
done

# Log and drop all other incoming traffic
iptables -A INPUT -j LOG --log-prefix "DROP: "
iptables -A INPUT -j DROP
