#!/bin/bash

if ! command -v rvm >/dev/null 2>&1 ; then
  echo "Could not find ruby version manager. Please install 'rvm' and try again."
  exit
fi

echo "Installing ruby..."
echo "-------------------------------------------------------------------------------"

rvm install ruby-2.3.0
rvm alias create cryptikit-ruby ruby-2.3.0

echo "Installing gems..."
echo "-------------------------------------------------------------------------------"

rvm cryptikit-ruby@global do gem install bundler
rvm cryptikit-ruby do rvm gemset create cryptikit
rvm cryptikit-ruby@cryptikit do bundle install --without development
rvm cryptikit-ruby@cryptikit do bundle clean --force

cd .
