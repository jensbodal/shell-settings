
**`.screenrc`**
```bash
# without this, screen won't respond to the escape sequences, even if they're defined in terminfo or termcap.
altscreen on
# set escape sequence to ctrl+shift+6
escape ^^^
# ...
utf8 on
# disable startup message so we can just startup back where we left off
startup_message off
# defines the time screen delays a new message when another is currently displayed. Defaults to 1 second.
msgwait 0

# optional: set to directory you want your sessions to start
# chdir /home/foo/bar
```

**`.zshenv`**
```bash
# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.

export LANG=en_US.utf8
export STARTED_SCREEN=${STARTED_SCREEN:-0}
export TERM=${TERM:-NOTERM}

main() {
  # internet says this might not be a useful or reliable check
  if [ "$PS1" = "" ]; then
    return 0;
  fi

  # if ssh session then should be filled in
  if [ "${SSH_TTY:-x}" = x ]; then
    return 0;
  fi

  if [ $STARTED_SCREEN -eq 0 ]; then
    print "\n[$USER@$HOST:$PWD]\n"

    # anything else you want to run before rejoining or starting screen

    STARTED_SCREEN=1
    echo "[~/.zshenv] setting up screen session"
    # set to absolute path of screen bin
    /home/linuxbrew/.linuxbrew/bin/screen -RR -S zshenv && exit 0
    # You will only see this message if screen fails
    echo "Screen failed! continuing with normal bash startup"
  else
    echo "[~/.zshenv] attached to a new screen session"
    if [ -f /etc/motd ]; then
      cat /etc/motd
    fi
  fi
}

main "$@"
# [end of auto-screen snippet]
```
