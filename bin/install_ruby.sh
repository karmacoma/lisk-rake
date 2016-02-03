#!/bin/bash

if ! command -v rvm >/dev/null 2>&1 ; then
  echo "Could not find ruby version manager. Please install 'rvm' and try again."
  exit
fi

echo "Installing ruby..."
echo "-------------------------------------------------------------------------------"

rvm install ruby-2.3.0
rvm alias create lisk-rake-ruby ruby-2.3.0

echo "Installing gems..."
echo "-------------------------------------------------------------------------------"

rvm lisk-rake-ruby@global do gem install bundler
rvm lisk-rake-ruby do rvm gemset create lisk-rake
rvm lisk-rake-ruby@lisk-rake do bundle install --without development
rvm lisk-rake-ruby@lisk-rake do bundle clean --force

cd .
