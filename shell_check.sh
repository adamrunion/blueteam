#!/bin/bash

echo "The following shell connections are currently open: "

# Get a list of all open connections
netstat -an | grep ESTABLISHED | grep -E "(:22|:23)" | awk '{print $5}' | cut -d: -f1 | sort | uniq > /tmp/open_connections

# Loop through each IP address in the list and check for open shell connections
while read ip; do
    username=$(who | grep $ip | awk '{print $1}')
    count=$(ps -ef | grep ssh | grep "@$ip" | grep -v grep | wc -l)
    if [ $count -gt 0 ]; then
        echo "Open shell connection found from IP address $ip, user: $username"
    fi
done < /tmp/open_connections

echo "Done."
