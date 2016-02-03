#!/bin/bash

cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

echo "Backing up configuraton..."
echo "-------------------------------------------------------------------------------"

cp -vi config.yml config.bak

echo "Downloading GPG public key..."
echo "-------------------------------------------------------------------------------"

. "bin/recv-keys.sh"

echo "Updating lisk-rake..."
echo "-------------------------------------------------------------------------------"

mkdir -p tmp
cp -f config.bak tmp/
cd tmp

if ! command -v curl >/dev/null 2>&1 ; then
  echo "Could not find curl. Please install 'curl' and try again."
  exit
else
  curl -L -o lisk-rake.tar.gz https://github.com/LiskHQ/lisk-rake/tarball/master
fi

if ! command -v tar >/dev/null 2>&1 ; then
  echo "Could not find tar. Please install 'tar' and try again."
  exit
else
  tar -zxvf lisk-rake.tar.gz --strip 1
fi

if [ -f ./config.bak ] && [ -f ../config.bak ]; then
  rm -rf ../*.*
  cp -f *.* ../
fi

cd ..

#### "Installing ruby / gems..."
#### "-------------------------------------------------------------------------------"

. "bin/install_ruby.sh"

echo "Updating configuraton..."
echo "-------------------------------------------------------------------------------"

rvm lisk-rake-ruby@lisk-rake do ruby "bin/update_config.rb"

echo "Cleaning up..."
echo "-------------------------------------------------------------------------------"

rm -rf lisk-rake.tar.gz tmp

echo "Done."
echo "-------------------------------------------------------------------------------"
