# Installation
# COPY symlink jens-disagrees theme to ohmyzsh themes folder
# create ~/.zsh-homerc file containing something like: export ZSH=/home/username/.oh-my-zsh
# create ~/.aliasrc file
###########################################################################################

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
#setopt appendhistory autocd
bindkey -v


# Path to your oh-my-zsh installation.
# e.g. a file containing something like: export ZSH=/home/username/.oh-my-zsh
source ~/.zsh-homerc
# npm config set prefix=$HOME/node


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"
#ZSH_THEME="ys"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="crunch"
ZSH_THEME="jens-disagrees"
#ys.zsh-theme
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
plugins=(git)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='mvim'
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
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}

zle -N up-line-or-local-history
zle -N down-line-or-local-history
bindkey OA up-line-or-local-history
bindkey OB down-line-or-local-history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     vim -- $files
     print -l $files[1]
  fi
}


alias gf='grep --line-buffered --color=never -r "" * | fzf'

jens() {
  local file
  file=$(grep --line-buffered --color=never -r "" * | fzf | sed -r 's#(.*):.*#\1#g')

  if [[ -n $file ]]
  then
    vim -- $file
    print -l $file
  fi
}

# Global Aliases for all installations
alias s="source ~/.zshrc"
alias hist="history"

# Read custom aliases from file
ALIAS_FILE=~/.aliasrc
source $ALIAS_FILE
