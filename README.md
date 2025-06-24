# Agent Configuration Files

This repository uses several configuration files to guide AI agents and tools:

## CLAUDE.md
- **Purpose**: Project-specific instructions for Claude Code
- **Contains**: Repository overview, setup commands, architecture details, testing procedures
- **Usage**: Automatically loaded by Claude Code to understand project context and conventions

## .claude/settings.json
- **Purpose**: Default permissions for Claude Code (committed to repo)
- **Contains**: Read-only permissions by default (safe for all users)
- **Usage**: Provides baseline security - users override in local settings for write access

## .claude/settings.local.json
- **Purpose**: Personal Claude Code permissions (not committed)
- **Contains**: User-specific permissions like `Edit(*)`, `Write(*)`, `Bash(*)`
- **Usage**: Allows individual users to grant write permissions as needed

## AGENTS.md
- **Purpose**: Documentation for all AI agent tools and workflows
- **Contains**: Branch naming conventions, dev container setup, general agent guidelines
- **Usage**: Reference for maintaining consistency across different AI tools

## .vibe/ Directory Structure
- **Purpose**: Project and task management for AI agents
- **Structure**:
  - `.vibe/projects/<project-slug>/` - Main project folders
  - `.vibe/projects/<project-slug>/<project-slug>.project.md` - Project overview
  - `.vibe/projects/<project-slug>/tasks/<timestamp>-<task-slug>.task.md` - Individual tasks
- **Usage**: Agents create projects here before starting work to track progress and maintain organization

# Using Automated Scripts

1. Install ZSH using your OS package manager or build from source
2. Install oh-my-zsh using provided script
3. Run setup script
4. If npm not installed, install npm
5. Run post setup instal script
6. Install pre-commit (e.g. `pip install pre-commit` or via your OS package manager)

## Git Hooks

We use [pre-commit](https://pre-commit.com/) to manage Git hooks across environments. To install Git hooks, run:

```bash
pre-commit install --install-hooks --hook-type pre-commit --hook-type pre-push
```

If you use npm, the hooks are installed automatically on `npm install` via the `prepare` script in `package.json`.

# Use absolute links when symlinking

e.g. `ln -sf /home/owner/shell-settings/folder /home/owner/.vim/folder`

# ~/.zsh-homerc

`export ZSH=/home/owner/.oh-my-zsh`

# For git submodules (e.g. ctrlp)

`git submodule update --init`

## YouCompleteMe

### Ensure all additional software is installed
```bash
sudo apt-get install exuberant-ctags npm vim
```

### Building YouCompleteMe
```bash
cd ~/.vundle/plugins/YouCompleteMe
./install.py --all
```

# Extra packages to install

```
# https://github.com/direnv/direnv/blob/master/docs/development.md
direnv
jq
zsh
...
```
# Notes

```
:w !sudo tee %
```

