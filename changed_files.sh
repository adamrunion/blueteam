#!/bin/bash
# This script searches the entire root directory for files that have recently changed

echo "Searching for recently changed files in the root directory..."

# Find all files in the root directory that have been modified within the last 30 minutes
find / -type f -mmin -30 -print > /tmp/recently_changed_files

# Check if any recently changed files were found
if [ -s /tmp/recently_changed_files ]; then
    echo "The following files have been modified within the last 30 minutes:"
    
    # Loop through each file and print its path
    while read file; do
        echo $file
    done < /tmp/recently_changed_files
else
    echo "No files have been modified within the last 30 minutes."
fi

echo "Done."
