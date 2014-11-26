#!/bin/bash

if command -v gpg >/dev/null 2>&1 ; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
fi
