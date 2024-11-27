#!/bin/bash

# Function to print the directory tree
print_tree() {
    local dir="$1"
    local prefix="$2"

    # List all entries (files and directories)
    local entries=("$dir"/*)
    local total=${#entries[@]}
    local count=1

    for entry in "${entries[@]}"; do
        local basename=$(basename "$entry")
        if [ -d "$entry" ]; then
            # If it's the last directory, use `--`, otherwise use `|--`
            if [ $count -eq $total ]; then
                echo "${prefix}-- $basename/"
                print_tree "$entry" "$prefix    "
            else
                echo "${prefix}|-- $basename/"
                print_tree "$entry" "$prefix|   "
            fi
        else
            if [ $count -eq $total ]; then
                echo "${prefix}-- $basename"
            else
                echo "${prefix}|-- $basename"
            fi
        fi
        count=$((count + 1))
    done
}

# Start from the root of the directory structure
root_dir="../lib"
echo "$root_dir/"
print_tree "$root_dir" "" | pbcopy

# Inform the user
echo "Directory tree copied to clipboard."
