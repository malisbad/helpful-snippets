#!/bin/bash

# Define the folder where the static assets are located
STATIC_FOLDER="./static"

# Find all image files in the static folder and its subdirectories
IMAGES=$(find "$STATIC_FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

# Loop through each image file found
for IMAGE in $IMAGES; do
  # Get the filename and extension of the image
  FILENAME=$(basename "$IMAGE")
  EXTENSION="${FILENAME##*.}"

  # Convert the image to .avif or .webp format using cwebp or avifenc
  if [ "$EXTENSION" == "jpg" ] || [ "$EXTENSION" == "jpeg" ]; then
    OUTPUT_FORMAT="webp"
    cwebp -quiet "$IMAGE" -o "${IMAGE%.*}.$OUTPUT_FORMAT"
  elif [ "$EXTENSION" == "png" ]; then
    OUTPUT_FORMAT="avif"
    avifenc -quiet "$IMAGE" "${IMAGE%.*}.$OUTPUT_FORMAT"
  fi

  # Replace the original image with the converted one
  if [ -f "${IMAGE%.*}.$OUTPUT_FORMAT" ]; then
    # Get the directory structure of the original image
    DIR="$(dirname "$IMAGE")"
    # Make sure the destination folder exists
    mkdir -p "$DIR"
    # Replace the original image with the converted one
    mv -f "${IMAGE%.*}.$OUTPUT_FORMAT" "$DIR/$FILENAME"
  fi
done

exit 0
