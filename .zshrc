# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export OS="unknown"

export BUN_INSTALL=$HOME/local/bun
export N_PREFIX=$HOME/local/n
export PNPM_HOME=$HOME/local/pnpm
export ZSH=$HOME/.oh-my-zsh

PATH="$PATH:$PNPM_HOME"
PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH"

if type uname > /dev/null; then
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  if [ "$OS" = "linux" ]; then
    if [[ "`uname -a`" =~ "Linux.*pve.*" ]]; then
      OS="proxmox"
    fi
  fi
fi

setopt HIST_IGNORE_ALL_DUPS
bindkey -v
fpath=($HOME/.zsh_completions $fpath)

## Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# colored completion - use my LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  aliases # use with acs
  #fzf
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
# Local environment overrides
################################################################################################
source ~/.zsh-homerc
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# direnv
################################################################################################
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
elif [ -f $HOME/.local/share/mise/installs/direnv/latest/bin/direnv ]; then
  eval "$($HOME/.local/share/mise/installs/direnv/latest/bin/direnv hook zsh)"
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# mise (formerly mise)
################################################################################################
if command -v mise > /dev/null; then
#  export mise_USE_TOML=1
  eval "$(mise activate zsh)"
#  echo "eval \"\$(/Users/bodal/.local/bin/mise activate zsh)\"" >> "/Users/bodal/.zshrc"
#  eval "$(mise activate zsh)"
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################################################################################
# load/update omz settings and activate
################################################################################################
ZSH_THEME="jens-disagrees"
source $ZSH/oh-my-zsh.sh
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false

export AWS_EC2_METADATA_DISABLED=true

if [ -f $HOME/github/shell-settings/scripts/shell-settings-update ]; then
  shell-settings-update
else
  echo "Could not find shell-settings-update script"
fi


# bun

# bun completions
[ -s "/local/home/bodal/local/bun/_bun" ] && source "/local/home/bodal/local/bun/_bun"
