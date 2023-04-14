#!/bin/bash

echo "Deleting all SSH keys..."

# Loop through each user's authorized_keys file and delete all keys
for user in $(cut -f1 -d: /etc/passwd); do
    if [ -f "/home/$user/.ssh/authorized_keys" ]; then
        sudo sed -i '/^ssh-rsa/d' "/home/$user/.ssh/authorized_keys"
    fi
done

echo "Generating new SSH keys..."

# Loop through each user and generate new SSH keys
for user in $(cut -f1 -d: /etc/passwd); do
    sudo -u $user ssh-keygen -t rsa -b 4096 -N "" -f "/home/$user/.ssh/id_rsa"
done

echo "Done."
