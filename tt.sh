#!/bin/bash

#$HOME/github/shell-settings/scripts/jtime 'ollama run phi3 "42 is? (respond in 20 words or less)" --verbose' | tee "$HOME/github/shell-settings/out.tmp"
ollama run phi3 "42 is? (respond in 20 words or less)" --verbose 2>&1 | tee "$HOME/github/shell-settings/out.tmp"
