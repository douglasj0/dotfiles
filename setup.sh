#!/bin/bash

# Define your Stow directory with packages
STOW_DIR="$HOME/.dotfiles"

# Define your home directory
TARGET_DIR="$HOME"

# Change to the Stow directory
cd "$STOW_DIR" || { echo "Error: Could not change to Stow directory: $STOW_DIR"; exit 1; }

# Iterate through each subdirectory (package) in the Stow directory
for package in */; do
    # Remove trailing slash from package name
    package=${package%/}
    echo "Stowing package: $package"
    # Execute stow command for the current package
    # -d specifies the stow directory
    # -t specifies the target directory
    stow -d "$STOW_DIR" -t "$TARGET_DIR" "$package"
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to stow package: $package"
    fi
done

echo "All packages processed."
