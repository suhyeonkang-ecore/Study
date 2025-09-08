#!/bin/bash
set -euo pipefail

echo "LDAP Password Change Utility"

# User ID
read -p "Enter User ID (username): " USER_ID
LDAP_DN="uid=${USER_ID},ou=Users,dc=iREMB-R,dc=HPC"

# Current Password
read -s -p "Current Password: " CURRENT_PW
echo

# New Password
read -s -p "New Password: " NEW_PW
echo
read -s -p "Confirm new password: " NEW_PW_CONFIRM
echo

# check password
if [[ "$NEW_PW" != "$NEW_PW_CONFIRM" ]]; then
  echo "New Password do not match.."
  exit 1
fi

# apply
ldappasswd -x -D "$LDAP_DN" -w "$CURRENT_PW" -s "$NEW_PW"

if [[ $? -eq 0]]; then
  echo "Password changed successfully."
else
  echo "Failed to change password."
fi
