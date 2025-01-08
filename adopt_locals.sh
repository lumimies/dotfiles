#!/usr/bin/env zsh
# Move files from ~ to here, only if they're normal files
# For example, ~/.zshrc.local -> ~/dotfiles/zshrc.local

if [[ -z $DOTFILES ]]; then
  DOTFILES="$HOME/.dotfiles"
fi
setopt extended_glob
for file in $HOME/.*.local(#q.N); do
    local filename=$(basename $file)
    filename=${filename#.}
    echo Adopting $file
    mv $file $DOTFILES/$filename
    if [[ $? -ne 0 ]]; then
        echo "Error moving $file to $DOTFILES/$filename"
    fi
done