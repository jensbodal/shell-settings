# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
#setopt appendhistory autocd
setopt HIST_IGNORE_ALL_DUPS
bindkey -v
fpath=($HOME/.zsh_completions $fpath)

# Path to your oh-my-zsh installation.
# e.g. a file containing something like: export ZSH=/home/username/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"
#ZSH_THEME="ys"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="crunch"
ZSH_THEME="jens-disagrees"
#ZSH_THEME="agnoster"
#DEFAULT_USER="jens_bodal"

#ys.zsh-theme
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
#
# Local environment overrides
source ~/.zsh-homerc
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

# colored completion - use my LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  history
  history-substring-search
)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#

# Remap up/down arrows to go through local history
# Map page up/page down to go through global history
# All history is merged on end of terminal session
# http://superuser.com/a/691603
up-local-history-or-substring-search() {
  # if we have a buffer and it is equal to the last local buffer, then we are performing a local search
  # the buffer will differ from the local buffer only when we type additional keys
  if [ -z $BUFFER ] || [[ $BUFFER == $LOCAL_BUFFER ]]; then
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
    LOCAL_BUFFER="$BUFFER"
  else
    LOCAL_BUFFER=
    history-substring-search-up
  fi
}
down-local-history-or-substring-search() {
  # if we have a buffer and it is equal to the last local buffer, then we are performing a local search
  # the buffer will differ from the local buffer only when we type additional keys
  if [ -z $BUFFER ] || [[ $BUFFER == $LOCAL_BUFFER ]]; then
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
    LOCAL_BUFFER="$BUFFER"
  else
    LOCAL_BUFFER=
    history-substring-search-down
  fi
}
# register functions
zle -N up-local-history-or-substring-search
zle -N down-local-history-or-substring-search

# control+v[key] to see the keys
bindkey OA up-local-history-or-substring-search        # Cursor up
bindkey OB down-local-history-or-substring-search      # Cursor down
bindkey "^[[1;5A" up-local-history-or-substring-search   # [CTRL] + Cursor up
bindkey "^[[1;5B" down-local-history-or-substring-search # [CTRL] + Cursor down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Global Aliases for all installations
# If alias executes a command within $() then it should be called from a function
alias s="source ~/.zshrc && if type direnv > /dev/null; then direnv reload; fi"
alias hist="history"
alias json="python -m json.tool"
alias dc="docker-compose"
alias di="docker image"
alias cn="docker container"
alias git-vim-status=__git-vim-status
alias ff=__grep-file-name
alias fif=__fif
alias frif=__frif
alias cdt=__cd-to
alias brew-update=__brew-update
alias git-set-origin=__git-set-origin
alias whats-my-ip=__whats-my-ip
alias gs="git status"

function __git-vim-status() {
  vim -p $(git status -s | sed -r 's#^(.*->)?[ARMU? ]+(.*)$#\2#')
}

# cd to file
function __cd-to() {
  while [[ $PWD != '/' && ! -d "$1" ]]; do cd ..; done
}

function cdf() {
  cd $(dirname "$1")
}

# find file
function __grep-file-name() {
  local needle="${1:- }"
  local grepopts="$2"

  find . -iname "*$needle*" -type f | grep "$needle" $grepopts
}

# find in file
function __fif() {
  grep "$@" -r . | grep "$@"
}

function __frif() {
  targetword="$1"
  replaceword="$2"
  doreplace="$3"

  for file in `grep "$targetword" -Rl .`; do
    if [ "$doreplace" = "-i" ]; then
      sed -i'' -r "s#$targetword#$replaceword#g" "$file"
    else
      sed -r "s#$targetword#$replaceword#g" "$file" | grep "$targetword\|$replaceword"
    fi
  done

  if [ ! "$doreplace" = "-i" ]; then
    echo "\nNote:\n  use \"-i\" flag to actually replace"
  fi
}

function __brew-update () {
  # Update Brew Installs
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup -s
  brew cleanup
  # Run Diagnostics
  brew doctor
  brew missing
}

function __git-set-origin() {
  local currentbranch=$(git rev-parse --abbrev-ref HEAD)
  git branch --set-upstream-to=origin/$currentbranch $currentbranch
}

function __whats-my-ip() {
  dig +short myip.opendns.com @resolver1.opendns.com
  # curl ifconfig.co
}
# END GLOBAL ALIASES

# Read custom aliases from file
ALIAS_FILE=~/.aliasrc
source $ALIAS_FILE

export UID
export GID
eval "$(direnv hook zsh)"
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true
