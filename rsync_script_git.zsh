#!/bin/sh

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <local_directory_path>"
    exit 1
fi

# Local directory path
LOCAL_DIR="$1"

# Remote details
REMOTE_USER_HOST="root@192.168.2.115"
REMOTE_DIR="/Application/sd-card-mount/RODECaster"

# Rsync command
/opt/homebrew/bin/rsync -avh --progress "$REMOTE_USER_HOST":"$REMOTE_DIR/" "$LOCAL_DIR" --info=progress2

echo "Sync complete."

