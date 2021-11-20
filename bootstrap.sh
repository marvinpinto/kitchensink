#!/usr/bin/env bash

set -e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Linux pre-reqs
if [[ "$(uname)" == "Linux" ]]; then
  sudo apt-get install -y build-essential procps curl file git
fi

# On linux systems, create the linuxbrew role + directory and assign the
# "marvin" user read/write permissions there
if [[ "$(uname)" == "Linux" ]]; then
  sudo groupadd -f linuxbrew
  sudo mkdir -p /home/linuxbrew
  sudo chown root:linuxbrew /home/linuxbrew
  sudo chmod 0775 /home/linuxbrew
  sudo adduser marvin linuxbrew
fi

# Download & install homebrew
rm -f /tmp/install-homebrew
curl -o /tmp/install-homebrew -fsSL "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
chmod +x /tmp/install-homebrew
/tmp/install-homebrew
rm -f /tmp/install-homebrew

# Post-install steps
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Bootstrap apps
brew analytics off
brew install gcc git ansible chezmoi
