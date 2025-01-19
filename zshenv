if [[ -z "$DOTFILES_ROOT" ]]; then
  DOTFILES_ROOT=$HOME/.dotfiles

  local cache_file="$HOME/.dirs_to_prepend_cache"
  local -aU dirs_to_prepend
  # If the cache file doesn't exist, or is over a day old, regenerate it, otherwise read it
  if [[ ! -f "$cache_file" || "$(date -r "$cache_file" +%s)" -lt "$(( $(date +%s) - 86400 ))" ]]; then
      # Otherwise, generate the directories to prepend and cache them in the file
      local -U candidate_dirs
      dirs_to_prepend=()
      candidate_dirs=(
        "/usr/local/sbin"
        "/usr/local/git/bin"
        "/usr/local/bin"
        "/usr/local/mysql/bin"
        "/sw/bin"
        "$DOTFILES_ROOT/bin"
        "$HOME/bin"
        "$HOME/.rvm/bin"
        "$HOME/go/bin"
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
      )
      if whence brew >/dev/null; then
        candidate_dirs+=(
          "$(brew --prefix ruby)/bin"
          "$(brew --prefix)/share/npm/bin" # Add npm-installed package bin
        )
      fi
      # Remove any directories that don't exist
      for dir in "${candidate_dirs[@]}"; do
        [[ -d "$dir" ]] && dirs_to_prepend+=("$dir")
      done
      printf '%s\n' "${dirs_to_prepend[@]}" > "$cache_file"
  else
      # If the cache file exists, read the directories to prepend from it
      dirs_to_prepend=("${(f)$(<$cache_file)}")
  fi

  # Clean antidote paths
  while x=${path[(I)**/antidote/**]}; [[ $x > 0 ]]; do
    path[$x]=()
  done
  while x=${path[(I)~/.*/**]}; [[ $x > 0 ]]; do
    path[$x]=()
  done

  for dir in ${(k)dirs_to_prepend[@]}
  do
    if [[ -d "${dir}" && -z "${path[(r)$dir]}" ]]; then
      # If these directories exist, then prepend them to existing PATH
      path=("${dir}" "${path[@]}")
    fi
  done

  unset dirs_to_prepend cache_file
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
fi
if [[ -e "$HOME/.zshenv.local" ]]; then
    source "$HOME/.zshenv.local"
fi
