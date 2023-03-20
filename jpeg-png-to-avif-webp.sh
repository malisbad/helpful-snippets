#!/bin/sh

# Define the folder that contains the static image assets
IMAGES_FOLDER="path/to/images"

# Loop through all the image files in the folder
for file in $IMAGES_FOLDER/*.{jpg,jpeg,png}; do
    # Get the file extension
    ext="${file##*.}"

    # Convert the image to either the .avif or .webp format
    if [ "$ext" = "jpg" ] || [ "$ext" = "jpeg" ]; then
        cwebp -q 75 "$file" -o "${file%.*}.webp"
    elif [ "$ext" = "png" ]; then
        avifenc -j 8 "$file" -o "${file%.*}.avif"
    fi

    # Replace the original asset with the converted asset
    if [ -f "${file%.*}.webp" ] || [ -f "${file%.*}.avif" ]; then
        rm "$file"
        mv "${file%.*}.webp" "$file" || mv "${file%.*}.avif" "$file"
    fi
done

exit 0
