#!/bin/bash

echo "Backing up configuraton..."
echo "-------------------------------------------------------------------------------"

if [ -f "config.bak" ]; then
   echo "-> Backup already exists. Leaving config.bak intact."
else
   echo "-> Moving existing config.yml to config.bak."
   mv config.yml config.bak
fi

echo "Updating cryptikit..."
echo "-------------------------------------------------------------------------------"

git fetch --tags
git checkout `git describe --abbrev=0 --tags` -B stable

echo "Done."
echo "-------------------------------------------------------------------------------"
