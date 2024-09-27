#!/bin/bash

# URL of the JSON file
JSON_URL="https://storage.googleapis.com/panels-api/data/20240916/media-1a-i-p~s"

# Create directories to store the downloaded files
mkdir -p downloaded_files
mkdir -p json_data

# Download the JSON file
echo "Locating the prisoners"
curl -s -o "json_data/media.json" "$JSON_URL"
echo "Prisoners found"

# Initialize counter
counter=0
total_files=$(grep -o 'https://panels-cdn\.imgix\.net[^"]*' json_data/media.json | wc -l)

# ASCII art frames for the liberator
liberator_frames=(
    "  O  "
    " /|\\ "
    " / \-~~-----0"
    "  O  "
    " /|\\ "
    " / \--~~----0"
    "  O  "
    "-/|\\ "
    " / \----~~--0"
    "  O  "
    "-/|\\-"
    " / \------~~0"
)

# Function to display the file liberation animation
display_animation() {
    local prison_width=40
    local frame=$((counter))

    clear  # Clear screen
    echo "Unshackle the files"
    echo

    # Liberator
    for ((i=0; i<3; i++)); do
        echo "${liberator_frames[frame*3 + i]}  $(printf '%0.s$' $(seq 1 $((counter/20))))"
    done
    echo

    # Prison
    printf "+%${prison_width}s+\n" | tr ' ' '-'
    local files_inside=$((total_files - counter))
    printf "|%-${prison_width}s|\n" "$(printf '%0.s$' $(seq 1 $files_inside))"
    printf "+%${prison_width}s+\n" | tr ' ' '-'

    echo
    echo "Files liberated: $counter / $total_files"
}

# Function to download a file
download_file() {
    local url="$1"
    local filename=$(basename "$url" | cut -d'?' -f1)
    curl -s -o "downloaded_files/$filename" "$url"
    ((counter++))
    display_animation
}

# Read the JSON file and extract URLs
echo "Extracting URLs and downloading files..."
grep -o 'https://panels-cdn\.imgix\.net[^"]*' json_data/media.json | sort -u | while read -r url; do
    download_file "$url"
done

echo -e "\nAll $total_files files have been liberated and downloaded to the 'downloaded_files' directory."
echo "MKBSD's digital prison has been emptied, and the files are free!"
