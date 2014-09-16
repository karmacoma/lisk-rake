#!/bin/bash

echo "Backing up configuraton..."
echo "-------------------------------------------------------------------------------"
printf "\n"

if [ -f "config.bak" ]; then
   echo "-> Backup already exists. Leaving backup intact."
else
   echo "-> Moving existing config.yml to config.bak."
   mv config.yml config.bak
fi

printf "\n"
echo "Updating cryptikit..."
echo "-------------------------------------------------------------------------------"
printf "\n"

git fetch origin master
git checkout `git describe --abbrev=0 --tags` -B stable

printf "\n"
echo "Done."
echo "-------------------------------------------------------------------------------"
