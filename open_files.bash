#!/bin/bash

# Get a list of all processes
processes=$(ps aux)

# Create an empty array to store open files by user
declare -A open_files_by_user

# Iterate over each process
while read -r line; do
    # Get the process owner
    process_owner=$(echo "$line" | awk '{print $1}')
    
    # Get the process ID
    process_id=$(echo "$line" | awk '{print $2}')
    
    # Get a list of open files for the process
    open_files=$(ls -l /proc/"$process_id"/fd/ | awk '{print $11}')
    
    # Add each open file to the array, keyed by the process owner
    for open_file in $open_files; do
        if [[ -n "$open_file" ]]; then
            if [[ ${open_files_by_user[$process_owner]+_} ]]; then
                open_files_by_user["$process_owner"]+=" $open_file"
            else
                open_files_by_user["$process_owner"]="$open_file"
            fi
        fi
    done
done <<< "$processes"

# Print the list of open files by user
for process_owner in "${!open_files_by_user[@]}"; do
    echo "$process_owner:"
    for open_file in ${open_files_by_user["$process_owner"]}; do
        echo -e "\t$open_file"
    done
done
