# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

[[ -f "${HOME}/github/shell-settings/.private/zshrc.pre.zsh" ]] && builtin source "${HOME}/github/shell-settings/.private/zshrc.pre.zsh"
[[ -f "${HOME}/.zshrc.pre.zsh" ]] && builtin source "${HOME}/.zshrc.pre.zsh"

[ -f "$HOME/.local/bin/mise" ] && export MISE_PATH="$HOME/.local/bin/mise"
[ -f "/opt/homebrew/bin/mise" ] && export MISE_PATH="/opt/homebrew/bin/mise"
[ -f "/home/linuxbrew/.linuxbrew/bin/mise" ] && export MISE_PATH="/home/linuxbrew/.linuxbrew/bin/mise"

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export OS="unknown"

export FAKE_HOME=$HOME/github/shell-settings/fakehome
export BUN_INSTALL=$HOME/local/bun
export N_PREFIX=$HOME/local/n
export PNPM_HOME=$HOME/local/pnpm
export ZSH=$HOME/.oh-my-zsh
export TLDR_AUTOUPDATE_DISABLED=1

PATH="$PATH:$PNPM_HOME"
PATH="$BUN_INSTALL/bin:$PATH"
PATH="$PATH:$PNPM_HOME"
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

.setupssh() {
  local SSH_DIR="${HOME}/.ssh"
  local SSH_CONFIG="${SSH_DIR}/config"
  local SSH_CONFIG_DIR="${SSH_DIR}/config.d"
  local SSH_CONFIG_SHELL_SETTINGS="${SSH_CONFIG_DIR}/shell-settings"

  .addtokeychain() {
    local identityFile="${1}"

    if [ -f "${identityFile}" ]; then
      if [ $OS = "darwin" ]; then
        eval `${FAKE_HOME}/../bin/keychain -q --inherit any --eval --agents ssh ${identityFile}`
      else
        eval `${FAKE_HOME}/../bin/keychain -q --eval --agents ssh ${identityFile}`
      fi
    fi
  }

  if [ -f "${SSH_CONFIG}" ]; then
    local includeline="Include ${SSH_CONFIG_DIR}/*"
    if ! grep -q "${includeline}" "${SSH_CONFIG}"; then
      cp "${SSH_CONFIG}" "${SSH_CONFIG}.bak.`date +%s`"

      echo -e "${includeline}\n\n$(cat ${SSH_CONFIG})" > "${SSH_CONFIG}"
    fi
  fi

  if [ ! -d "${SSH_CONFIG_DIR}" ]; then
    mkdir -p "${SSH_CONFIG_DIR}"
  fi

  cp "${FAKE_HOME}/.ssh/config.d/shell-settings" "${HOME}/.ssh/config.d/shell-settings"

  .hasextension() {
    local filename="$1"
    local filename_no_ext=`echo "$filename" | sed -E 's#(^.*)(\..*)$#\1#'`

    # Empty strings do not have extensions
    if [[ -z "$filename" ]]; then
      return 1
    fi

    # We do not have an extension if the filename without an extension is the same as one with one
    if [ "$filename_no_ext" = "$filename" ]; then
      return 1
    fi

    return 0
  }

  for d in `find "${HOME}/.ssh" -type d`; do
    chmod 700 "${d}"
  done


  for filepath in `find "${HOME}/.ssh" -maxdepth 1 -type f`; do
    filename=`basename $filepath`

    if [ "$filename" = "authorized_keys" ]; then
      chmod 644 "${filepath}"
      continue
    fi

    if [ "$filename" = "known_hosts" ]; then
      chmod 600 "${filepath}"
      continue
    fi

    if [[ $filename == *.pub ]]; then
      chmod 644 "${filepath}"
      continue
    fi

    # check filepath here because will cover *config* files and config.d/* files
    if [[ $filepath == *config* ]]; then
      chmod 600 "${filepath}"
      continue
    fi

    if [[ $filepath == *.ssh/environment* ]]; then
      # we don't need to do anything with these
      continue
    fi

    if .hasextension "$filename"; then
      # we don't need to do anything with these
      continue
    fi

    chmod 600 "${filepath}"
    .addtokeychain "${filepath}"
  done
}

.setupssh

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
elif [ -f $HOME/.local/bin/mise ]; then
  eval "$(${HOME}/.local/bin/mise activate zsh)"
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


################################################################################################
# bun
################################################################################################
# bun completions
[ -s "/local/home/bodal/local/bun/_bun" ] && source "/local/home/bodal/local/bun/_bun"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# no idea why this is here
if command -v bashcompinit > /dev/null; then
  autoload -U +X bashcompinit && bashcompinit
fi

[[ -f "${HOME}/github/shell-settings/.private/zshrc.post.zsh" ]] && builtin source "${HOME}/github/shell-settings/.private/zshrc.post.zsh"
[[ -f "${HOME}/.zshrc.post.zsh" ]] && builtin source "${HOME}/.zshrc.post.zsh"

if command -v mail && mail -e; then mail; fi
