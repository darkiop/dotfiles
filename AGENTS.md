## Overview

This repository contains personal shell dotfiles (bash/zsh) organized as modular components and submodules. Key goals for changes: be minimal, POSIX-friendly where reasonable, and preserve per-host feature flags.

## Quick entrypoints

- Installer: `install.sh` (also runnable via the curl/wget one-liner in [README.md](../README.md)).
- Update: `cd ~/dotfiles && git pull --ff-only && git submodule update --init --recursive --depth 1` (see README.md "Updating").
- Autoupdate: `autoupdate.sh` controlled by `DOTFILES_ENABLE_AUTOUPDATE` in `config/local_dotfiles_settings`.

## Important files & places to change

- Configuration & flags: `components/feature_flags`, `components/platform`, and `config/local_dotfiles_settings` (gitignored) for host overrides.
- Shell entrypoints: `bashrc`, `zshrc`, `bash_profile`, `zprofile`.
- Prompt components: `components/prompt` (bash) and `components/prompt_zsh` (zsh).
- Modules: `modules/<name>/` — add an `install` script and `README.md` when adding new modules (see `modules/fzf`).
- tmux: `modules/oh-my-tmux/.tmux.conf.local` and `config/tmux.conf.local` for local overrides.
- Cheats and docs: `cheats/` contains many usage examples and keybindings.

## Conventions and patterns

- Per-host feature flags: prefer adding switches to `components/feature_flags` and expose toggles in `config/local_dotfiles_settings` rather than editing `bashrc` directly.
- Submodules: repo expects submodules for vim/tmux/fzf; `git clone --recurse-submodules` is the default install path. `gitconfig` sets `submodule.recurse=true`.
- Packaging: fzf and other tools are installed via module scripts (e.g., `modules/fzf/install --key-bindings --completion`) not distro packages.
- Platform detection: `components/platform` exports `DOTFILES_OS`, `DOTFILES_DISTRO_ID`, `DOTFILES_WSL`, and `DOTFILES_CONTAINER`. Use these variables for conditional logic.
- Line endings: keep LF (see `.gitattributes`). Avoid CRLF in shell files.

## Testing & validation

- Syntax-check shell changes with: `bash -n path/to/file` before committing.
- Quick manual test: source the relevant file (`source bashrc` or open a new shell) and verify prompt/completions.

## Editing guidance for AI agents

- Make small, focused edits. Preserve existing style and comments. Modifications that change user-facing defaults should be placed behind feature flags in `components/feature_flags`.
- When adding a new module, include an `install` script and `README.md` under `modules/<name>/` and document any prerequisites in the root `README.md`.
- Prefer runtime checks using `components/platform` rather than hardcoding OS checks.
- For updates affecting install flow, update `install.sh` and include idempotent checks (e.g., skip when already installed).

## Examples (where to implement common changes)

- Add new prompt segments: edit `components/prompt` and `components/prompt_zsh`.
- Add an alias set: create `alias/alias-<name>` and enable via `components/feature_flags`.
- Add a completion: put script into `bash_completion.d/` and enable via `DOTFILES_ENABLE_BASH_COMPLETION`.

If anything here is unclear or you want me to expand examples, tell me which area to iterate on.
