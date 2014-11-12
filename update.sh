#!/bin/bash

echo "Backing up configuraton..."
echo "-------------------------------------------------------------------------------"

if [ -f "config.bak" ]; then
   echo "-> Backup already exists. Leaving config.bak intact."
else
   echo "-> Copying existing config.yml to config.bak."
   cp -v config.yml config.bak
fi

echo "Updating cryptikit..."
echo "-------------------------------------------------------------------------------"

if ! command -v git >/dev/null 2>&1 ; then
   echo "Update requires installation of 'git'. Please install 'git' and try again."
   echo ""
   echo "You can always download the latest release of CryptiKit from:"
   echo "-> https://github.com/karmacoma/cryptikit/releases/latest"
   exit
fi

git fetch origin master
git checkout master
git reset --hard origin/master

git fetch --tags
git checkout `git describe --abbrev=0 --tags` -B release

echo "Updating ruby..."
echo "-------------------------------------------------------------------------------"

if ! command -v rvm >/dev/null 2>&1 ; then
  echo "Update requires installation of 'rvm'. Please install 'rvm' and try again."
  exit
fi

rvm get stable
rvm alias create cryptikit-ruby ruby-2.1.2
rvm cryptikit-ruby do rvm gemset create cryptikit

echo "Updating gems..."
echo "-------------------------------------------------------------------------------"

rvm cryptikit-ruby@cryptikit do bundle install --without development
rvm cryptikit-ruby@cryptikit do bundle clean --force

echo "Cleaning up..."
echo "-------------------------------------------------------------------------------"

rm -f .tasks

echo "Done."
echo "-------------------------------------------------------------------------------"
