# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

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
  history
  history-substring-search
)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

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

# Read custom aliases from file
source ~/.aliasrc
source ~/.aliasrc-shell-settings

export UID
export GID

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true
#export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

ZSH_THEME="jens-disagrees"
source $ZSH/oh-my-zsh.sh
