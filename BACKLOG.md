# Backlog

Merged from IDEAS.md + IMPROVEMENTS.md, then merged with TODO.md. Last reviewed: 2026-09-07.

**Status values:** `open` | `in-progress` | `done` | `dropped`

---

## High Priority

| ID | Title | Status | Notes |
|----|-------|--------|-------|
| IMP-001 | ioBroker source validation — add `[[ -f ]]` check before sourcing `~/.iobroker/*` files in `bashrc:213-214`, `zshrc:202-203` | open | 30 min |
| IMP-003 | Move WOL MAC addresses out of `alias/alias:310-314` into encrypted config or env vars | open | security |
| IMP-004 | Secret scanning — pre-commit hook via gitleaks/trufflehog + `dot secrets-scan`, whitelist for false positives | open | `components/secret_scanner`, flag `DOTFILES_ENABLE_SECRET_SCANNER` |
| IMP-006 | Docker widget: distinguish "daemon not running" from "0 containers" in `motd/widgets.sh:97-99` | open | check `docker info` first, show widget on 0 containers too |

---

## Medium Priority

### Performance

| ID | Title | Status |
|----|-------|--------|
| IMP-007 | `dot profile` — shell startup profiler, measure load time per component | open |
| IMP-009 | Feature-flag caching — compute flags once at startup, not 40+ times | done |

### Features

| ID | Title | Status | Ref |
|----|-------|--------|-----|
| IMP-010 | Directory bookmarks — `mark`, `jump`, `unmark`, `marks` commands, storage in `~/.dotfiles_bookmarks` | open | `components/bookmarks`, flag `DOTFILES_ENABLE_BOOKMARKS` |
| IMP-011 | Process manager — `psfzf` interactive process picker with kill/nice/renice/info | open | `components/fzf_process`, flag `DOTFILES_ENABLE_PROCESS_FZF` |
| IMP-012 | Installer dry-run — `install.sh --dry-run` preview mode, progress + rollback on error | open | |
| IDX-001 | Navi as proper git submodule (`modules/navi/`) analogous to fzf/oh-my-zsh, with `install` script | open | flag `DOTFILES_ENABLE_NAVI` already exists; currently vendored via `cheats/`, not `modules/` |
| IDX-006 | MOTD standard lines (hostname, uptime, last login) migrated into widget system for consistent config | open | |
| P001 | kubectl fzf helpers — `kpods`, `klogs`, `kexec`, `kdesc`, `kctx`, `kns` | open | `components/fzf_kubectl`, flag `DOTFILES_ENABLE_KUBECTL_FZF` |
| P005 | Extended git helpers — `gwip`, `gundo`, `gclean`, `gworktree`, `gbrowse`, `gblame-fzf` | open | extend `components/fzf_git` |
| P007 | Config validator — `dot validate`: shellcheck integration, syntax check all shell files, flag-typo detection, deprecated-feature detection, broken-source-ref check | open | extends `components/dot_doctor` (symlink check already in `dot_doctor`); merged with former IMP-025 |
| P014 | Audit log — `dot audit`, logs installs/updates/config changes with timestamp/operation/user/outcome | open | `components/audit_log`, flag `DOTFILES_ENABLE_AUDIT_LOG` |
| P022 | FZF preview enhancements — bat syntax highlighting, dynamic sizing, image preview, shared preview helpers | open | |

### Code Quality

| ID | Title | Status |
|----|-------|--------|
| IMP-016 | Add `set -euo pipefail` to `motd/motd.sh`, `motd/widgets.sh`, widget scripts (`install.sh` already has `set -e`) | open |
| IMP-017 | Array-based PATH management in bashrc/zshrc instead of repeated `ADD_TO_PATH` calls | open |
| IMP-018 | Split `components/fzf` (166 lines) into `fzf_core` + `fzf_tab_completion` | open |
| IMP-019 | Shellcheck audit — review 36 suppressions in 13 files, reduce SC2312/SC2086/SC1090 | open |

### Docs

| ID | Title | Status |
|----|-------|--------|
| IMP-013 | Architecture diagram — loading order visualization in README.md | open |
| IMP-014 | Troubleshooting guide — slow startup, macOS bash 3.2, WSL gotchas, container detection | open |
| IMP-015 | Compatibility matrix — bash 4+/zsh 5.0+, macOS vs Linux, container limits | open |

---

## Low Priority

### Organization

| ID | Title | Status |
|----|-------|--------|
| IMP-020 | Split `alias/alias` (372 lines) into `alias-core`, `alias-system`, `alias-dev` | open |
| IMP-022 | Reorganize 57 cheat files into `cheats/docker/`, `cheats/git/`, `cheats/kubernetes/` | open |
| IDX-004 | Docker output colorizer — optionally integrate better-docker-ps or docker-color-output | open |
| P008 | Snippet manager — `snip add/run/list/edit/delete`, template vars (`{{var}}`), fzf picker | open |
| P020 | History insights — `dot stats`, top-20 commands, alias suggestions, unused-feature detection | open |
| P024 | Network tools — `netfzf` (ports + process info), `curlfzf` (saved HTTP requests), `sshfzf` (active connections) | open |
| P025 | File finder — `ff [pattern]` with bat preview, actions, ripgrep full-text search, .gitignore support | open |
| P030 | Note-taking system — `note`, `note search`, markdown + tags, storage in `~/.notes/` | open |

### Architecture

| ID | Title | Status |
|----|-------|--------|
| IMP-021 | Plugin system — `plugins/` dir with auto-discovery for user extensions | open |
| P004 | Environment switcher — `dotenv list/switch/current`, cloud profile integration | open |
| P009 | Remote host manager — enhanced ssh_picker with metadata, tags, tunnels, storage in `config/hosts.json` | open |

### Testing & CI

| ID | Title | Status |
|----|-------|--------|
| IMP-023 | GitHub Actions CI — shellcheck validation on push | open |
| IMP-024 | BATS test suite — component loading, feature flags, FZF, MOTD | open |

### Compatibility

| ID | Title | Status |
|----|-------|--------|
| IMP-026 | Add `DOTFILES_WSL_VERSION` (1 or 2) to platform detection, alongside existing boolean `DOTFILES_WSL` | open |
| IMP-027 | macOS bash upgrade guide in README.md (bash 4+ for FZF tab completion) | open |

---

## Done

| ID | Title | Notes |
|----|-------|-------|
| IMP-002 | Remove hardcoded `$USER == "darkiop"` check | commit `4cf440d` — `DOTFILES_ENABLE_IOBROKER` flag + binary check gate it now |
| IMP-005 | Fix IPv6 detection in SSH tmux rename regex | commit `19f0455` |
| IMP-008 | Lazy-load rarely used components — wrapper registers on first call | commit `bb38295`, `components/lazy_loader` |
| P002 | Systemd unit manager with fzf | `components/fzf_systemctl` exists |
| — | Docker widget macOS: skip when Desktop not running | commit `38b3e87` |
| — | AGENTS.md / CLAUDE.md / copilot-instructions.md — natural language, no AI speak | done |

---

## Dropped / Out of Scope

| ID | Title | Reason |
|----|-------|--------|
| P015 | Cloud CLI helpers (AWS/GCP/Azure) | Too broad, external deps heavy |
| P016 | Database connection manager | Out of scope for personal dotfiles |
| P017 | AI helper integration | Claude Code covers this |
| P023 / IDX-003 | Fish/PowerShell support (incl. oh-my-posh) | High effort, low personal value |
| P026 | Clipboard manager | Desktop only, not relevant |
| P027 | Password manager CLI | Out of scope |
| P028 | Weather widget | Fun-only, not core to a shell dotfiles repo |
| P029 | Calendar integration | Out of scope |

---

## Quick Wins (< 1h each)

| Effort | Task | File(s) |
|--------|------|---------|
| 30 min | IMP-001: add `[[ -f ]]` before ioBroker source | `bashrc:213-214`, `zshrc:202-203` |
| 1h | IMP-016: `set -euo pipefail` in motd scripts | `motd/motd.sh`, `motd/widgets.sh` |
| 1h | IMP-006: Docker daemon-down detection | `motd/widgets.sh:97-99` |
| 1h | IMP-026: `DOTFILES_WSL_VERSION` detection | `components/platform` |
| 1h | IMP-027: macOS bash upgrade guide | `README.md` |
