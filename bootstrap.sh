#!/usr/bin/env bash

set -e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Linux pre-reqs
if [[ "$(uname)" == "Linux" ]]; then
  sudo apt-get update
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

# On linux systems, install and configure the locale/timezone data. This sometimes needs user intervention.
if [[ "$(uname)" == "Linux" ]]; then
  export TZ="America/Toronto"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo "$TZ" | sudo tee /etc/timezone > /dev/null
  sudo -E apt-get install -y --no-install-recommends language-pack-en-base tzdata
  sudo -E dpkg-reconfigure -f noninteractive tzdata
  echo "LANG=en_US.UTF-8" | sudo tee /etc/default/locale > /dev/null
  echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/default/locale > /dev/null
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  sudo -E locale-gen --purge en_US.UTF-8
  sudo -E dpkg-reconfigure -f noninteractive locales
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
elif [[ "$(uname)" == "Darwin" ]] && [[ "$(uname -m)" == "x86_64" ]]; then 
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Bootstrap apps
brew analytics off
brew install gcc git ansible chezmoi
