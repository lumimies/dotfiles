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

if [[ ! -f ~/.local/bin/eget ]]; then
  mkdir -p ~/.local/bin
  pushd ~/.local/bin
  echo "Installing eget"
  curl https://zyedidia.github.io/eget.sh | sh
  popd
fi
export EGET_BIN=$HOME/.local/bin
~/.local/bin/eget --upgrade-only starship/starship