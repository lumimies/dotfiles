
#zmodload zsh/zprof ## For profilin. run `zprof` to see the results

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/config.zsh"

export ZSH_CACHE_DIR="$HOME/.cache/zsh"
if [[ ! -e $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi

if ! type "antibody" > /dev/null; then
  curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
fi

if [[ -e ~/.antibody_plugins && ! ~/.antibody_plugins -ot ~/.antibody_plugins.sh || ! -d "$(antibody home)" ]]; then
  mkdir -p "$(antibody home)"
  antibody bundle < ~/.antibody_plugins > ~/.antibody_plugins.sh
fi

# https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2894219
_zpcompinit_custom() {
  setopt extendedglob local_options
  autoload -Uz compinit
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
  # in the background as this is doesn't affect the current session
  if [[ -f "$zcd"(#qN.m+1) ]]; then
        compinit -i -d "$zcd"
        { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
        compinit -C -d "$zcd"
        { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
}
# Create completions dir if it doesn't exist
if [[ ! -d "$ZSH_CACHE_DIR/completions" ]]; then
  mkdir -p "$ZSH_CACHE_DIR/completions"
fi
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# If homebrew installed, add homebrew completions
if whence brew > /dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
  if [[ -d "$(brew --prefix)/share/zsh-completions" ]]; then
    fpath=($(brew --prefix)/share/zsh-completions $fpath)
  fi
fi
# Need this to have the right fpath when running compinit
source <(grep '^fpath' ~/.antibody_plugins.sh)
_zpcompinit_custom
source <(grep -v '^fpath' ~/.antibody_plugins.sh)


export DEFAULT_USER=zohar

setopt auto_cd
export cdpath=(~/Projects)
# export MANPATH="/usr/local/man:$MANPATH"



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

alias zshconfig="$VISUAL ~/.zshrc"
alias sqlite=/usr/local/opt/sqlite/bin/sqlite3
# alias ohmyzsh="mate ~/.oh-my-zsh"
if type exa > /dev/null; then
  alias ls="exa --git -l"
fi

test -e "${HOME}/.zshrc.functions" && source "${HOME}/.zshrc.functions"
test -e "${HOME}/.zshrc.functions.local" && source "${HOME}/.zshrc.functions.local"
test -e "${HOME}/.zshrc.aliases" && source "${HOME}/.zshrc.aliases"
test -e "${HOME}/.zshrc.aliases.local" && source "${HOME}/.zshrc.aliases.local"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ -d $HOME/.pyenv ]]; then
  eval "$(pyenv init -)"
fi

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi