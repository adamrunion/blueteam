#!/bin/bash

# This script uses the "netstat" command to get a list of current connections on the system, filters out "TIME_WAIT" and "LISTEN" connections, and then displays the remaining connections. 
# The user is then prompted to enter 'y' if they want to disconnect any of the connections or 'n' to exit.
# If the user chooses to disconnect a connection, they are prompted to enter the IP address of the connection they want to disconnect. 
# The script then checks if the IP address is in the current connections list and if it is, it uses the "tcpkill" command to disconnect the connection. 
# If the IP address is not in the current connections list or if the user enters an invalid IP address, an error message is displayed.
# Note that this script must be run with sudo privileges in order to use the "tcpkill" command to disconnect connections.


# Get current connections
current_connections=$(netstat -an | grep -v "TIME_WAIT" | grep -v "LISTEN" | awk '{print $5}' | cut -d ":" -f 1 | sort | uniq)

# Display current connections and prompt for action
echo "Current Connections:"
echo "$current_connections"
read -p "Enter 'y' to disconnect any of the connections above, or 'n' to exit: " user_input

# If user chooses to disconnect connections
if [ "$user_input" == "y" ]; then
  read -p "Enter IP address to disconnect: " ip_address
  if [ -n "$ip_address" ]; then
    # Check if IP address is in the current connections list
    if echo "$current_connections" | grep -q "$ip_address"; then
      # Disconnect connection
      sudo tcpkill host $ip_address
      echo "Disconnected connection from $ip_address"
    else
      echo "IP address $ip_address is not in current connections list"
    fi
  else
    echo "Invalid IP address"
  fi
fi

# If user chooses to exit
if [ "$user_input" == "n" ]; then
  exit 0
fi
