#!/bin/bash

# Get a list of all local user accounts, excluding the current user and root
users=$(dscl . -list /Users | grep -v "^_" | grep -v "$(whoami)")

# Iterate over each user and delete their account and home directory
for user in $users; do
  echo "Deleting user: $user"
  dscl . -delete "/Users/$user"
  rm -rf "/Users/$user"
done
