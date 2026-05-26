#!/bin/bash

# basicshoot uninstaller

echo "Uninstalling basicshoot..."

# Remove the binary
if [ -f "/usr/local/bin/basicshoot" ]; then
    echo "Removing /usr/local/bin/basicshoot..."
    sudo rm /usr/local/bin/basicshoot
else
    echo "/usr/local/bin/basicshoot not found, skipping."
fi

# Remove the config directory
if [ -d "$HOME/.config/bs" ]; then
    echo "Removing $HOME/.config/bs..."
    rm -rf "$HOME/.config/bs"
else
    echo "$HOME/.config/bs not found, skipping."
fi

echo "basicshoot has been uninstalled."
