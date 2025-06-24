# Add wrapper script for Claude CLI installation and invocation

- Check if `claude` is on the PATH.
- If missing, install it via `npx @anthropic-ai/claude-code@latest --migrate-installer`.
- Execute `claude "\$@"` with the passed arguments.
- Ensure the script is executable and passes pre-commit checks.