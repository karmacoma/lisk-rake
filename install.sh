#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
  echo "Installing homebrew..."
  echo "-------------------------------------------------------------------------------"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Installing ssh-copy-id..."
  echo "-------------------------------------------------------------------------------"
  brew install ssh-copy-id
fi

echo "Downloading GPG public key..."
echo "-------------------------------------------------------------------------------"

. "$(pwd)/bin/recv-keys.sh"

echo "Installing rvm..."
echo "-------------------------------------------------------------------------------"

curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles

echo "Configuring environment..."
echo "-------------------------------------------------------------------------------"

export PATH="$PATH:$HOME/.rvm/bin"

if [[ $EUID -ne 0 ]]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
else
  [[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
fi

#### "Installing ruby / gems..."
#### "-------------------------------------------------------------------------------"

. "$(pwd)/bin/install_ruby.sh"

echo "Enabling bash auto-completion..."
echo "-------------------------------------------------------------------------------"

promptyn() {
  while true; do
    read -p "$1 " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
          * ) echo "Please answer yes or no.";;
    esac
  done
}

if promptyn "Do you wish to enable bash auto-completion?"; then
  rvm cryptikit-ruby@cryptikit do ruby "bin/completer.rb" --enable

  profiles=("$HOME/.bash_profile" "$HOME/.profile")

  for i in ${profiles[@]}; do
    if [ -f $i ]; then
      source $i
      break
    fi
  done

  echo ""
  echo "* Bash auto-completion was enabled."
  echo ""
else
  echo ""
  echo "* Bash auto-completion was not enabled."
  echo ""
fi

echo "Done."
echo "-------------------------------------------------------------------------------"
