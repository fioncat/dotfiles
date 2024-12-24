#!/usr/bin/env python3

import sys
import os
from PIL import Image


def convert_to_png(input_path):
    # Create a temporary PNG file path
    temp_png_path = input_path + '.tmp.png'
    try:
        # Check if input file exists
        if not os.path.exists(input_path):
            print(f"Error: File '{input_path}' does not exist")
            return False

        # Convert image to PNG
        with Image.open(input_path) as img:
            img.save(temp_png_path, 'PNG')

        # Remove the original file
        os.remove(input_path)

        # Get the new filename (replace jpg extension with png)
        new_path = os.path.splitext(input_path)[0] + '.png'

        # Rename the temporary file to the final name
        os.rename(temp_png_path, new_path)

        print(f"Conversion successful: '{input_path}' -> '{new_path}'")
        return True

    except Exception as e:
        print(f"Conversion failed: {str(e)}")
        # Clean up temporary file if it exists
        if os.path.exists(temp_png_path):
            os.remove(temp_png_path)
        return False


def main():
    # Check command line arguments
    if len(sys.argv) != 2:
        print("Usage: python convert-png.py <image_path>")
        sys.exit(1)

    # Get input file path
    input_path = sys.argv[1]

    # Execute conversion
    if not convert_to_png(input_path):
        sys.exit(1)


if __name__ == "__main__":
    main()
