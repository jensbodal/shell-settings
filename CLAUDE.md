# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal shell settings and dotfiles repository that provides:
- Comprehensive shell configuration (zsh, vim, direnv)
- Cross-platform development environment setup
- Custom utility scripts and tools
- AI/LLM client tooling
- System automation and benchmarking tools
- Infrastructure management utilities (Proxmox, containers)

## Setup Commands

### Initial Setup
```bash
# Install prerequisites and setup environment
./setup.sh              # Main setup script - creates symlinks and basic config
./post_setup.sh          # Install package managers, tools, and runtime environments
npm install              # Install Node.js dependencies and setup pre-commit hooks
```

### Python Development
```bash
# Install Python dependencies using uv (managed via mise)
uv sync                  # Install dependencies and dev dependencies from pyproject.toml
uv run pytest           # Run Python tests
uv run black .           # Format Python code
uv run isort .           # Sort imports
```

### Git Hooks
```bash
# Setup pre-commit hooks (automatically done via npm install)
pkgx pre-commit install --install-hooks --hook-type pre-commit --hook-type pre-push
```

## Architecture

### Core Components

**Shell Configuration System**
- `.zshrc` - Main zsh configuration with modular loading
- `.generic.env` - Cross-platform environment variables
- `setup_symlinks.sh` - Manages symlinks from this repo to home directory
- `scripts/_INIT` - Common initialization script providing logging, error handling, and utilities

**Package Management Strategy**
- Uses `mise` (formerly rtx) for runtime version management
- `uv` for Python package management and virtual environments
- Falls back to native package managers (brew, apt, pacman)
- Custom `pkgx` integration for reproducible tooling
- Maintains `~/local/` prefix for user-installed binaries

**Scripts Architecture**
- `scripts/` directory contains 60+ utility scripts
- All scripts can source `scripts/_INIT` for common functionality
- Platform-specific scripts in `scripts/osx/`, `scripts/proxmox/`, etc.
- Script path automatically added to PATH via `_INIT`

### LLM Integration

**LLM Client (`llm_cli.py`, `llm_client.py`)**
- Python-based CLI for interacting with various LLM APIs
- Automatic fallback capability between different LLM providers
- Configurable model selection and parameters
- Environment variable driven configuration
- Managed with `uv` for fast, reliable dependency resolution

**AI Benchmarking (`ai/benchmark/`)**
- Systematic benchmarking across different LLM models
- Results stored by model, architecture, and system configuration
- MCP (Model Context Protocol) specification testing

#### Development Environment

**Branch Naming Conventions**
- When creating branches, use the `claude/` prefix (e.g., `claude/add-feature`, `claude/fix-bug`)
- Other AI tools should use their respective prefixes as documented in `AGENTS.md`
- This helps maintain clear attribution and prevents conflicts between different AI coding tools

**Pre-commit Hooks**
- Uses `trufflehog` for secret detection on pre-push
- Uses `gitleaks` for additional security scanning
- All tools managed via `pkgx` for reproducibility

**Dev Container Support**
- `.devcontainer/devcontainer.json` provides containerized development
- Includes Python, Node.js, Rust toolchains
- Automatic setup via `postCreateCommand`

## Key Global Variables

When scripts source `_INIT`, these variables become available:
- `$SHELL_SETTINGS_DIR` - Path to this repository
- `$SCRIPTS_DIR` - Path to scripts directory  
- `$(.SCRIPT_DIR)` - Function returning current script's directory
- `$(.SCRIPT_NAME)` - Function returning current script name

## Important Files

- `setup.sh` / `post_setup.sh` - Environment bootstrap scripts
- `setup_symlinks.sh` - Dotfile symlink management
- `scripts/_INIT` - Common script initialization and utilities
- `.pre-commit-config.yaml` - Git hook configuration using pkgx
- `pyproject.toml` - Python package configuration with dev dependencies
- `package.json` - Node.js dependencies and npm scripts for pre-commit setup

## Testing

- Python tests: `uv run pytest` (test files: `test_*.py`)
- Manual testing: `integration_test.py` for LLM client functionality
- No automated test runners configured - tests run manually

## Platform Support

Designed to work across:
- macOS (Darwin) with Homebrew and system-specific optimizations
- Linux (Ubuntu/Debian, Arch, RHEL-based) with native package managers
- ARM64/aarch64 and x86_64 architectures
- Proxmox virtualization environments
- Development containers