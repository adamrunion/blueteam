#!/bin/bash

# Set variables
user="username"
host="hostname"
connections=10

# Loop through connections to create multiple SSH connections
for ((i=1; i<=$connections; i++))
do
    # Establish SSH connection with the -N flag to keep the connection open
    ssh -N $user@$host &
done

# Wait for all background processes to finish
wait
