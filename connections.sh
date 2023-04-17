#!/bin/bash

# Use grep to find the string "Accepted password for" in the /var/log/auth.log file
grep "Accepted password for" /var/log/auth.log | \

# Use awk to extract the relevant fields: username, IP address, and port number
awk '{print $9, $11}' | \

# Use sed to remove unnecessary characters and extract the IP address and port number
sed -r 's/.*from (.*):([0-9]+).*/\1 \2/'

# Use awk to add the port number to the output
awk '{print $1, $2, $3}' OFS=':'
