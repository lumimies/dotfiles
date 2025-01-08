#!/usr/bin/env zsh

# Don't clone if already exists
if [[ ! -d ${ZDOTDIR:-~}/.antidote ]]; then
  echo "Installing antidote"
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

if [[ ! -d ${ZDOTDIR:-~}/.atuin ]]; then
  echo "Installing atuin"
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
if [[ -e ~/.local/bin/starship ]]; then
  # Check Starship version against latest
  local latest_version=$(curl --silent "https://api.github.com/repos/starship/starship/releases/latest" | perl -nle 'print $1 if /"tag_name": "v(\d+\.\d+\.\d+)"/')
  # Starship --version prints something like "starship 1.21.1" on the first line and then other stuff
  local current_version=$(starship --version | head -n 1 | cut -d ' ' -f 2)
  if [[ $latest_version != $current_version ]]; then
    echo "Updating starship from $current_version to $latest_version"
    curl -fsSL https://starship.rs/install.sh | sh -s -f -b ~/.local/bin
  fi
else
  echo "Installing starship"
  curl -fsSL https://starship.rs/install.sh | sh -s -f -b ~/.local/bin
fi