DOTFILES_ROOT=$HOME/.dotfiles

# Directories to be prepended to $PATH
typeset -U dirs_to_prepend=(
  "/usr/local/sbin"
  "/usr/local/git/bin"
  "/usr/local"
  "/usr/local/mysql/bin"
  "/sw/bin"
  "$HOME/dotfiles/bin"
  "$HOME/bin"
  "$HOME/.rvm/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
)
if whence brew >/dev/null; then
dirs_to_prepend+=(
  "$(brew --prefix ruby)/bin"
  "$(brew --prefix coreutils)/libexec/gnubin" # Add brew-installed GNU core utilities bin
  "$(brew --prefix)/share/npm/bin" # Add npm-installed package bin
)
fi
# Explicitly configured $PATH
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
for dir in ${(k)dirs_to_prepend[@]}
do
  if [ -d ${dir} ]; then
    # If these directories exist, then prepend them to existing PATH
    PATH="${dir}:$PATH"
  fi
done

unset dirs_to_prepend

export PATH

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR="edit"
fi
export VISUAL="$EDITOR"

if [[ -e "$HOME/.zshenv.local" ]]; then
    source "$HOME/.zshenv.local"
fi

# if type jenv > /dev/null; then
#   eval "$(jenv init -)"
# fi