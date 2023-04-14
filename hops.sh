#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo "Getting list of connections to this machine..."

netstat -tnp | grep -v 'LISTEN' | awk '{print $5}' | cut -d: -f1 | sort | uniq > connections.txt

echo "Calculating number of hops to each connection..."

while read line; do
  echo "Connection from: $line"
  traceroute -m 20 $line | tail -n +2 | awk '{print $2}' | sed 's/*/\n/g' | uniq | wc -l | awk '{print "Number of hops: " $1}'
done < connections.txt

rm connections.txt

echo "Done."
