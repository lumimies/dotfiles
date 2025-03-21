#zmodload zsh/zprof ## For profilin. run `zprof` to see the results

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/config.zsh"

export ZSH_CACHE_DIR="$HOME/.cache/zsh"
if [[ ! -e $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi
unset ZSH # Needed when upgrading OMZ when switching to friendly names
zstyle ':antidote:bundle' use-friendly-names 'yes'
# Fix for slow pasting
# See https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-921932705
zstyle :bracketed-paste-magic active-widgets '.self-*'
# Load Antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
# Support for general plugins in .txt, and local plugins in .txt.local
if [[ ! $zsh_plugins.txt -nt $DOTFILES/zsh_plugins.txt || ! $zsh_plugins.txt -nt $DOTFILES/zsh_plugins.txt.local  ]]; then
  # This awk script is necessary in case one of the files doesn't end in a newline
  awk 'FNR==1 {if (NR > 1 && !prev_empty) print ""; print "# " FILENAME} {prev_empty=($0=="")?1:0} 1'  $DOTFILES/zsh_plugins.txt(|.local) > $zsh_plugins.txt
fi
antidote load



export DEFAULT_USER=zohar

setopt auto_cd
export cdpath=(~/Projects)
# export MANPATH="/usr/local/man:$MANPATH|
if (( $+commands[ansifilter] )); then
  DISABLE_AUTO_TITLE="true"
  function set_win_title(){
    title "$(
      (starship module hostname;
      starship module directory) | ansifilter
    )"
  }

  precmd_functions+=(set_win_title)
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
if whence starship > /dev/null; then
  eval "$(starship init zsh)"
else
  zstyle :prompt:pure:prompt:success color green
  PURE_PROMPT_SYMBOL=λ
fi


for file in "$HOME"/.zshrc.(functions|aliases)(|.local|.(#i)$(hostname -s))(#qN)
  do
  source "$file"
done

if [[ -d $HOME/.pyenv ]]; then
  smartcache eval pyenv init -
fi

if (( $+commands[direnv] )) ; then
  smartcache eval direnv hook zsh
fi

if (( $+commands[pnpm] )) && pnpm  &>/dev/null ; then
  smartcache eval pnpm completion zsh
fi

if [[ -e "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  smartcache eval atuin init zsh --disable-up-arrow
  smartcache comp atuin gen-completions --shell zsh
fi

if [[ -d $HOME/.rvm ]]; then
  # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  export PATH="$PATH:$HOME/.rvm/bin"
fi

export LESS="--mouse --use-color --quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS"

export EGET_BIN=$HOME/.local/bin

if (( $+commands[broot] )); then
  smartcache eval broot --print-shell-function zsh
fi

if (( $+commands[pkgx] )) ; then
  smartcache eval pkgx dev --shellcode
fi
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi