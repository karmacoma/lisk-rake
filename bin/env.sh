#!/bin/bash

export PATH="$PATH:$HOME/.rvm/bin"

if [[ $EUID -ne 0 ]]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
else
  [[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
fi
