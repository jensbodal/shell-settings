# Investigate and Replace `pkgx` Usage

**Objective:**

This task is to investigate all occurrences of `pkgx` within the `shell-settings` repository and replace them with more standard and robust solutions.

**Background:**

The `pkgx` utility was previously used for package management and script execution. To improve the project's maintainability and adhere to best practices, we are moving away from `pkgx` and using more common tools like Homebrew for package installation and direct binary calls in scripts.

**Key Areas to Investigate:**

*   **`CLAUDE.md`**: Update documentation to remove references to `pkgx`.
*   **`.aliasrc-shell-settings`**: Replace `pkgx`-based aliases with direct calls to the corresponding binaries.
*   **`scripts/pkgx`**: Remove this wrapper script.
*   **`scripts/pkgm`**: Update the script to use `brew` for `pkgm` installation.
*   **`scripts/password`**: Update the script to call `pwgen` directly.
*   **`scripts/i`**: Update the script to use `brew` for package installation.
*   **`scripts/gopass`**: Remove this wrapper script and use direct calls to `gopass`.
*   **`scripts/generate-sk`**: Update the user-facing message to remove the mention of `pkgx`.
*   **`ai/bin/readme.md`**: Update documentation to remove references to `pkgx`.
*   **`ai/bin/install-litellms.sh`**: Replace the `pkgx` shebang with a standard `bash` shebang and add instructions for installing dependencies.

**Acceptance Criteria:**

*   All instances of `pkgx` are removed from the repository.
*   All scripts and documentation are updated to use the new, standardized methods.
*   The repository remains fully functional after the changes are implemented.
