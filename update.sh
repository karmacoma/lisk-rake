#!/bin/bash

echo "Backing up configuraton..."
echo "-------------------------------------------------------------------------------"

cp -vi config.yml config.bak

echo "Downloading GPG public key..."
echo "-------------------------------------------------------------------------------"

. "$(pwd)/bin/recv-keys.sh"

echo "Updating cryptikit..."
echo "-------------------------------------------------------------------------------"

mkdir -p tmp
cp -f config.bak tmp/
cd tmp

if ! command -v curl >/dev/null 2>&1 ; then
  echo "Could not find curl. Please install 'curl' and try again."
  exit
else
  curl -L -o cryptikit.tar.gz https://github.com/karmacoma/cryptikit/tarball/master
fi

if ! command -v tar >/dev/null 2>&1 ; then
  echo "Could not find tar. Please install 'tar' and try again."
  exit
else
  tar -zxvf cryptikit.tar.gz --strip 1
fi

if [ -f ./config.bak ] && [ -f ../config.bak ]; then
  rm -rf ../*.*
  cp -f *.* ../
fi

cd ..

#### "Installing ruby / gems..."
#### "-------------------------------------------------------------------------------"

. "$(pwd)/bin/install_ruby.sh"

echo "Updating configuraton..."
echo "-------------------------------------------------------------------------------"

rvm cryptikit-ruby@cryptikit do ruby "bin/update_config.rb"

echo "Cleaning up..."
echo "-------------------------------------------------------------------------------"

rm -rf cryptikit.tar.gz tmp

echo "Done."
echo "-------------------------------------------------------------------------------"
