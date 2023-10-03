#!/bin/bash

# Check if the user provided a username as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username="$1"
shadow_entry=$(grep "^$username:" /etc/shadow)

if [ -z "$shadow_entry" ]; then
    echo "User not found"
    exit 1
fi

password_expiry_date=$(echo "$shadow_entry" | cut -d: -f3)
password_expiry_days=$((password_expiry_date - $(date +%s) / 86400))

if [ "$password_expiry_days" -lt 0 ]; then
    echo "Password has expired"
elif [ "$password_expiry_days" -eq 0 ]; then
    echo "Password will expire today"
else
    echo "Password will expire in $password_expiry_days days"
fi
