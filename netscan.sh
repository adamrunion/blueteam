#!/bin/bash

# Prompt the user for the target subnet to scan
read -p "Enter the subnet to scan (e.g. 192.168.1.0/24): " subnet

# Run the Nmap scan on the target subnet using a more aggressive timing template
nmap -sV -T4 -p 1-65535 -oN /tmp/nmap_scan $subnet > /dev/null 2>&1

# Print the results of the scan
echo "Hosts found:"
grep "Nmap scan report" /tmp/nmap_scan | awk '{print $5}' | while read host; do
  echo "  Host: $host"
  echo "    Hostname: $(nmap -sL $host | grep $host | awk '{print $5}')"
  echo "    Open Ports:"
  grep "open" /tmp/nmap_scan | grep $host | awk '{print "      "$1"/"$3" "$4" "$5" "$6}'
done
