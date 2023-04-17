#!/bin/bash

# Prompt for IP address and port number
echo -n "Enter IP address: "
read ip_address
echo -n "Enter port number: "
read port_number

# Find the process ID (PID) of the connection
pid=$(sudo netstat -nlp | grep "$ip_address:$port_number" | awk '{print $7}' | cut -d'/' -f1)

if [[ -z "$pid" ]]; then
  echo "No connection found on $ip_address:$port_number"
  exit 1
fi

# Kill the process
sudo kill -9 "$pid"

echo "Connection to $ip_address:$port_number has been killed"
