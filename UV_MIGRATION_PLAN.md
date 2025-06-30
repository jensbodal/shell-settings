# UV Migration Implementation Plan

## Overview
Migrate Python development workflow from pip/pipx to uv, ensuring it's enforced in our gitflow process.

## Phase 1: Commit Current Changes
- [x] Updated pyproject.toml with hatchling backend and uv config
- [x] Updated .mise.toml to include uv
- [x] Updated post_setup.sh to install uv via mise  
- [x] Updated CLAUDE.md documentation
- [ ] **TODO**: Commit these changes with appropriate message

## Phase 2: Test Modern Python Workflow
- [ ] Ensure mise and uv are available in environment
- [ ] Run `uv sync` to install dependencies
- [ ] Test `uv run pytest` (verify tests pass)
- [ ] Test `uv run black .` (verify formatting works)
- [ ] Test `uv run isort .` (verify import sorting works)
- [ ] Validate that all commands work as expected

## Phase 3: Enforce in Git Workflow
- [ ] Examine current .pre-commit-config.yaml
- [ ] Add uv-based checks to pre-commit hooks:
  - Python formatting with `uv run black --check`
  - Import sorting with `uv run isort --check-only`
  - Linting if applicable
  - Test execution with `uv run pytest`
- [ ] Test pre-commit hooks locally
- [ ] Update documentation about PR requirements

## Phase 4: CI/CD Integration
- [ ] Check for existing GitHub Actions workflows
- [ ] Update any CI workflows to use uv instead of pip
- [ ] Ensure CI installs and uses uv for Python tasks
- [ ] Test workflow changes if possible

## Phase 5: NX Integration (Future)
- [ ] Locate nx polyglot+projen project
- [ ] Analyze project structure and requirements
- [ ] Integrate uv workflow into nx project configuration
- [ ] Update projen configuration if needed

## Success Criteria
- All Python development commands use `uv run` prefix
- Pre-commit hooks enforce uv-based checks
- CI/CD pipelines use uv for Python tasks
- Documentation reflects new workflow
- Pull requests automatically validate Python code quality

## Validation Steps
1. Fresh clone test: Clone repo and run setup scripts
2. Development workflow test: Make changes, run checks, commit
3. Pre-commit validation: Ensure hooks catch formatting/test issues
4. Documentation accuracy: Verify all commands in docs work