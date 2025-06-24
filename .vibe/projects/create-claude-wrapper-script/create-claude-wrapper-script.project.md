# create-claude-wrapper-script

Create a script at `scripts/claude` that wraps installation and invocation of the Claude CLI tool.

## Context

This repository contains shell scripts for developer utilities. We want to add a wrapper for the Claude CLI:

- Check if `claude` is on the PATH.
- If missing, install it via `npx @anthropic-ai/claude-code@latest --migrate-installer`.
- Then execute `claude "$@"`.

## Tasks

- Create the wrapper script at `scripts/claude`.
- Make the script executable.
- Run pre-commit on the new script.