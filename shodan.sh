#!/bin/bash

# Function to download Shodan output for a domain
download_shodan_output() {
    local DOMAIN="$1"
    local OUTPUT_FILE="$2"

    # Make the API request to Shodan using Shodan CLI
    echo "Downloading Shodan output for domain: $DOMAIN"
    shodan search --limit 1000 --fields ip_str,port ssl:"$DOMAIN" | awk '{print $1":"$2}' >> "$OUTPUT_FILE"
}

# Check if Shodan CLI is installed
command -v shodan >/dev/null 2>&1 || { echo >&2 "Shodan CLI is required but not installed. Aborting."; exit 1; }

# Check if the input file exists
if [ ! -f domains.txt ]; then
    echo "Input file 'domains.txt' not found."
    exit 1
fi

# Output file
OUTPUT_FILE="shodan_output.txt"

# Iterate through each domain in the input file
while IFS= read -r DOMAIN; do
    QUERY="$DOMAIN"
    download_shodan_output "$QUERY" "$OUTPUT_FILE"
done < "domains.txt"

echo "Shodan output saved to $OUTPUT_FILE"
