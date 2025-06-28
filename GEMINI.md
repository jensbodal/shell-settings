# Gemini Agent Guidelines

This document outlines the conventions and workflow for the Gemini AI agent when working in this repository.

## General Workflow

Before starting any task, I will adhere to the general agent workflow outlined in `AGENTS.md`. This includes creating a project and task structure within the `.vibe/` directory.

## Branching

All branches created by me will follow the prefix `gemini/`. For example:

- `gemini/feature/new-script`
- `gemini/bugfix/fix-zsh-completion`
- `gemini/refactor/improve-llm-client`

## Commits

I will follow the conventional commit format (`<type>: <subject>`). Commit messages will be clear and concise, explaining the "why" behind the changes.

Example:

```
feat: add support for Gemini Pro

This commit introduces a new function to handle requests to the Gemini Pro model, expanding the capabilities of the LLM client.
```

## Testing and Code Quality

Before committing, I will:

1.  **Run linters and formatters**: I will use `black` and `isort` to format Python code, as configured in `pyproject.toml`.
2.  **Execute tests**: I will run the appropriate tests to ensure my changes haven't introduced any regressions. For Python code, this will typically involve running `pytest`.

By following these guidelines, I will ensure my contributions are consistent with the project's standards.
