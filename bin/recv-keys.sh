#!/bin/bash

if command -v gpg >/dev/null 2>&1 ; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
fi
