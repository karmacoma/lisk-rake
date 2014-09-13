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

\curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles

echo "Configuring environment..."
echo "-------------------------------------------------------------------------------"

export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

echo "Installing gems..."
echo "-------------------------------------------------------------------------------"

rvm ruby-2.1.2 do rvm gemset create cryptikit
rvm ruby-2.1.2@cryptikit do bundle install

echo "Done."
echo "-------------------------------------------------------------------------------"

bash --login