# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export OS="unknown"

if type uname > /dev/null; then
  OS=$(uname | tr '[:upper:]' '[:lower:]')
fi

setopt HIST_IGNORE_ALL_DUPS
bindkey -v
fpath=($HOME/.zsh_completions $fpath)

## Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Local environment overrides
source ~/.zsh-homerc

# colored completion - use my LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  aliases # use with acs
  direnv
  fzf
  history
  history-substring-search
  iterm2
  ssh-agent
)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

################################################################################################
# Auto append sudo/defaults commands to log files
################################################################################################
__promptcommand() {
  local d=`date +"%F %T"`
  echo "[$d] $(history -n | tail -n 1 | grep "defaults write")" | sed '/^$/d' >> $HOME/.hist_defaults
  echo "[$d] $(history -n | tail -n 1 | grep "sudo")" | sed '/^$/d' >> $HOME/.hist_sudo
}

export PROMPT_COMMAND=__promptcommand

precmd() { eval "$PROMPT_COMMAND" }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

export UID
export GID

################################################################################################
# Read custom aliases from file
################################################################################################
source ~/.aliasrc
source ~/.aliasrc-shell-settings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# OS specific settings
################################################################################################
if [ $OS = "darwin" ]; then
  zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# asdf
################################################################################################
## source asdf here and set auto-completions because they work better than the zsh plugin
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  source "$HOME/.asdf/asdf.sh"
  fpath+=(${ASDF_DIR}/completions)
  export FZF_BASE=`asdf where fzf`
fi

## add asdf-direnv script here so it doesn't get appended to the bottom when enabling the plugin
if type direnv>/dev/null; then
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc" ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
  fi
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# load/update omz settings and activate
################################################################################################
ZSH_THEME="jens-disagrees"
source $ZSH/oh-my-zsh.sh
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

