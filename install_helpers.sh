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

if [[ ! $+commands[eget] ]]; then
  curl https://zyedidia.github.io/eget.sh | sh
fi
export EGET_BIN=$HOME/.local/bin
eget --upgrade-only starship/starship