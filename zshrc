#zmodload zsh/zprof ## For profilin. run `zprof` to see the results

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/config.zsh"

export ZSH_CACHE_DIR="$HOME/.cache/zsh"
if [[ ! -e $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi

# Load Antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
# Support for general plugins in .txt, and local plugins in .txt.local
if [[ ! $zsh_plugins.txt -nt $DOTFILES/zsh_plugins.txt || ! $zsh_plugins.txt -nt $DOTFILES/.zsh_plugins.txt.local  ]]; then
    cat $DOTFILES/zsh_plugins.txt $DOTFILES/.zsh_plugins.txt.local > $zsh_plugins.txt
fi
. "$HOME/.atuin/bin/env"
antidote load



export DEFAULT_USER=zohar

setopt auto_cd
export cdpath=(~/Projects)
# export MANPATH="/usr/local/man:$MANPATH|



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
if type eza > /dev/null; then
  alias ls="eza --git -l --color-scale --icons"
fi

for file in ".zshrc.functions" \
  ".zshrc.functions.local" \
  ".zshrc.aliases" \
  ".zshrc.aliases.local" \
  ".iterm2_shell_integration.zsh"; do
  test -e "${HOME}/$file" && source "${HOME}/$file"
done

if [[ -d $HOME/.pyenv ]]; then
  smartcache eval pyenv init -
fi

if type direnv > /dev/null; then
  smartcache eval direnv hook zsh
fi

if type pnpm > /dev/null && pnpm  &>/dev/null ; then
  smartcache eval pnpm completion zsh
fi
if [[ $+commands[atuin] -eq 1 ]] ; then
  smartcache eval atuin init zsh
  smartcache eval atuin gen-completions --shell zsh
fi

