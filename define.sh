#!/bin/bash

# Gets a list of definitions from dictionaryapi.dev and lists them
# Helpful for very fast defs without opening a browser

# Define the URI
BASE_URI="https://api.dictionaryapi.dev/api/v2/entries/en/"

# Get arg
WORD=$1

#full URI
FULL_URI="${BASE_URI}${WORD}"

result=$(curl -s -L "$FULL_URI")

# Check if the response is empty or null
if [ -z "$result" ] || [ "$result" == "null" ]; then
  echo "Error: Received empty or null response"
  exit 1
fi

echo "$result" | jq -r '.[].meanings[].definitions[].definition' | nl -n ln
