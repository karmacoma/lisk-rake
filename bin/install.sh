#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
  echo "Installing homebrew..."
  echo "-------------------------------------------------------------------------------"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Installing ssh-copy-id..."
  echo "-------------------------------------------------------------------------------"
  brew install ssh-copy-id
fi

echo "Installing rvm..."
echo "-------------------------------------------------------------------------------"

\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles

echo "Configuring environment..."
echo "-------------------------------------------------------------------------------"

[[ -s "bin/env.sh" ]] && source "bin/env.sh"
[[ -s "env.sh" ]] && source "env.sh"

echo "Installing ruby..."
echo "-------------------------------------------------------------------------------"

rvm install ruby-2.1.2

echo "Installing gems..."
echo "-------------------------------------------------------------------------------"

rvm ruby-2.1.2 do rvm gemset create cryptikit
rvm ruby-2.1.2@cryptikit do bundle install

echo "Done."
echo "-------------------------------------------------------------------------------"
