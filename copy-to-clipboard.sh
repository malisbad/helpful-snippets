#!/bin/bash

# Function to copy input to the clipboard
copy_to_clipboard() {
    if command -v pbcopy &> /dev/null; then
        pbcopy
    elif command -v xclip &> /dev/null; then
        xclip -selection clipboard
    elif command -v xsel &> /dev/null; then
        xsel --clipboard --input
    else
        echo "Error: No clipboard utility found." >&2
        return 1
    fi
}

# Main script starts here
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file>" >&2
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist." >&2
    exit 1
fi

cat "$1" | copy_to_clipboard
