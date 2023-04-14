#!/bin/bash
# This script pulls the list of users from a Linux machine

echo "The following users are currently configured on this machine:"

# Get a list of users from the /etc/passwd file and print each username
cut -d: -f1 /etc/passwd | sort | uniq | while read user; do
    echo $user
done

echo "Done."
