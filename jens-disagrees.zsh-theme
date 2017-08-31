# On a mac with snow leopard, for nicer terminal colours:

# - Install SIMBL: http://www.culater.net/software/SIMBL/SIMBL.php
# - Download'Terminal-Colours': http://bwaht.net/code/TerminalColours.bundle.zip
# - Place that bundle in ~/Library/Application\ Support/SIMBL/Plugins (create that folder if it doesn't exist)
# - Open Terminal preferences. Go to Settings -> Text -> More
# - Change default colours to your liking.
#
# Here are the colours from Textmate's Monokai theme:
#
# Black: 0, 0, 0
# Red: 229, 34, 34
# Green: 166, 227, 45
# Yellow: 252, 149, 30
# Blue: 196, 141, 255
# Magenta: 250, 37, 115
# Cyan: 103, 217, 240
# White: 242, 242, 242

# Thanks to Steve Losh: http://stevelosh.com/blog/2009/03/candy-colored-terminal/

# The prompt

#PROMPT='%{$fg[red]%}%{$fg[blue]%}%n%{$fg[red]%}@%{$fg[blue]%}%m%{$fg[red]%}:%{$fg[blue]%}%c%{$fg[red]%} %{$reset_color%}'
#PROMPT='%{$fg[blue]%}%c%{$fg[red]%} %{$reset_color%}'
PROMPT='%{$fg[red]%}[%{$fg[blue]%}%c%{$fg[red]%}%{$fg[red]%}] %{$reset_color%}'

# The right-hand prompt

RPROMPT='${time} %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}%{$reset_color%}'

# Add this at the start of RPROMPT to include rvm info showing ruby-version@gemset-name
# %{$fg[yellow]%}$(~/.rvm/bin/rvm-prompt)%{$reset_color%}

# local time, color coded by last return code
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%})%{$fg[yellow]%} Ø"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[magenta]%})%{$fg[green]%} ✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} A"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} D"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} R"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} U"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[red]%} 𝝙"
