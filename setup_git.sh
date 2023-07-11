#!/bin/bash

setglobal() {
  git config --global "$1" "$2"
}

setglobal user.email "jensbodal@gmail.com"
setglobal user.name "Jens Bodal"
setglobal init.defaultbranch main
setglobal core.editor vim
setglobal core.excludesfile /$HOME/.gitignore

setglobal branch.autosetupmerge always
setglobal branch.autosetuprebase always
setglobal pull.ff only
setglobal pull.rebase  true
setglobal merge.ff only
setglobal rebase.abbreviateCommands true
setglobal rebase.autoStash true
setglobal rebase.stat true
setglobal remote.pushDefault origin
setglobal status.showUntrackedFiles all
setglobal stash.showIncludeUntracked

