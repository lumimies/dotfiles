HIST_STAMPS="yyyy-mm-dd"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
DOTFILES_ROOT=$HOME/.dotfiles

# Directories to be prepended to $PATH
declare -a dirs_to_prepend
dirs_to_prepend=(
  "/usr/local/sbin"
  "/usr/local/git/bin"
  "/usr/local/"
  "/usr/local/mysql/bin"
  "/sw/bin/"
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
PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
for dir in ${(k)dirs_to_prepend[@]}
do
  if [ -d ${dir} ]; then
    # If these directories exist, then prepend them to existing PATH
    PATH="${dir}:$PATH"
  fi
done

unset dirs_to_prepend

export PATH

source $DOTFILES_ROOT/antigen/antigen.zsh
antigen init $HOME/.antigenrc

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# User configuration


export DEFAULT_USER=zohar

setopt auto_cd
export cdpath=(~/Projects)
# export MANPATH="/usr/local/man:$MANPATH"

# source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR="edit"
fi
export VISUAL="$EDITOR"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"


alias zshconfig="$VISUAL ~/.zshrc"
alias sqlite=/usr/local/opt/sqlite/bin/sqlite3
# alias ohmyzsh="mate ~/.oh-my-zsh"
#zstyle :omz:plugins:ssh-agent identities id_rsa id_github dev.pem
# zstyle :omz:plugins:ssh-agent agent-forwarding on

test -e "${HOME}/.zshrc.functions" && source "${HOME}/.zshrc.functions"
test -e /usr/local/share/zsh/site-functions/_aws && source /usr/local/share/zsh/site-functions/_aws
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if whence thefuck > /dev/null; then
  eval "$(thefuck --alias)"
fi

if whence jenv > /dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
