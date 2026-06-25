# Backlog

Merged from IDEAS.md + IMPROVEMENTS.md. Last reviewed: 2026-06-25.

**Status values:** `open` | `in-progress` | `done` | `dropped`

---

## High Priority

| ID | Title | Status | Notes |
|----|-------|--------|-------|
| IMP-001 | ioBroker source validation — add `[[ -f ]]` check before sourcing `~/.iobroker/*` files in `bashrc:209`, `zshrc:197` | open | 30 min |
| IMP-002 | Remove hardcoded `$USER == "darkiop"` in `bashrc:208`, `zshrc:196` — replace with feature flag or drop | open | 30 min |
| IMP-003 | Move WOL MAC addresses out of `alias/alias:310-314` into encrypted config or env vars | open | security |
| IMP-004 | Secret scanning — pre-commit hook via gitleaks/trufflehog (see P013) | open | |
| IMP-005 | IPv6 in SSH tmux rename — `bashrc:195` regex `^[0-9]+(\.[0-9]+){3}$` only matches IPv4; add `|| [[ $target =~ : ]]` | open | 1h |
| IMP-006 | Docker widget: distinguish "daemon not running" from "0 containers" in `motd/widgets.sh:87-91` | open | macOS path-fix done; Linux distinction still missing |

---

## Medium Priority

### Performance

| ID | Title | Status |
|----|-------|--------|
| IMP-007 | `dot profile` — shell startup profiler, measure load time per component (P006) | open |
| IMP-008 | Lazy-load rarely used components — define stub, source on first call | open |
| IMP-009 | Feature-flag caching — compute flags once at startup, not 40+ times | open |

### Features

| ID | Title | Status | Ref |
|----|-------|--------|-----|
| IMP-010 | Directory bookmarks — `mark`, `jump`, `unmark`, `marks` commands | open | P003 |
| IMP-011 | Process manager — `psfzf` interactive process picker with kill/nice | open | P012 |
| IMP-012 | Installer dry-run — `install.sh --dry-run` preview mode | open | P018 |
| P001 | kubectl fzf helpers — `kpods`, `klogs`, `kexec`, `kctx`, `kns` | open | `components/fzf_kubectl` |
| P005 | Extended git helpers — `gwip`, `gundo`, `gclean`, `gworktree`, `gbrowse` | open | extend `components/fzf_git` |
| P022 | FZF preview enhancements — bat syntax highlighting, dynamic sizing | open | |

### Code Quality

| ID | Title | Status |
|----|-------|--------|
| IMP-016 | Add `set -euo pipefail` to `install.sh`, `motd/motd.sh`, `motd/widgets.sh`, widget scripts | open |
| IMP-017 | Array-based PATH management in bashrc/zshrc instead of repeated `ADD_TO_PATH` calls | open |
| IMP-018 | Split `components/fzf` (166 lines) into `fzf_core` + `fzf_tab_completion` | open |
| IMP-019 | Shellcheck audit — review 36 suppressions in 13 files, reduce SC2312/SC2086/SC1090 | open |

### Docs

| ID | Title | Status |
|----|-------|--------|
| IMP-013 | Architecture diagram — loading order visualization in README.md | open |
| IMP-014 | Troubleshooting guide — slow startup, macOS bash 3.2, WSL gotchas | open |
| IMP-015 | Compatibility matrix — bash 4+/zsh 5.0+, macOS vs Linux, container limits | open |

---

## Low Priority

### Organization

| ID | Title | Status |
|----|-------|--------|
| IMP-020 | Split `alias/alias` (372 lines) into `alias-core`, `alias-system`, `alias-dev` | open |
| IMP-022 | Reorganize 57 cheat files into `cheats/docker/`, `cheats/git/`, etc. | open |
| P008 | Snippet manager — `snip add/run/list/edit/delete`, template vars | open |
| P019 | Theme switcher — `dot theme list/set/current` | open |
| P020 | History insights — `dot stats`, top commands, suggest aliases | open |
| P021 | MOTD extensions — Kubernetes widget, per-host custom widgets, weather | open |
| P030 | Note-taking system — `note`, `note search`, markdown + tags | open |

### Architecture

| ID | Title | Status |
|----|-------|--------|
| IMP-021 | Plugin system — `plugins/` dir with auto-discovery (P010) | open |
| P004 | Environment switcher — `dotenv list/switch/current`, cloud profile integration | open |
| P009 | Remote host manager — enhanced ssh_picker with metadata, tunnels | open |

### Testing & CI

| ID | Title | Status |
|----|-------|--------|
| IMP-023 | GitHub Actions CI — shellcheck validation on push | open |
| IMP-024 | BATS test suite — component loading, feature flags, FZF, MOTD | open |
| IMP-025 | `dot doctor` — add syntax check, flag validation, symlink health | open |

### Compatibility

| ID | Title | Status |
|----|-------|--------|
| IMP-026 | Add `DOTFILES_WSL_VERSION` (1 or 2) to platform detection | open |
| IMP-027 | macOS bash upgrade guide in README.md (bash 4+ for FZF tab completion) | open |
| P023 | Multi-shell support — Fish + PowerShell Core | open |

---

## Done

| ID | Title | Notes |
|----|-------|-------|
| P002 | Systemd unit manager with fzf | `components/fzf_systemctl` exists |
| — | Docker widget macOS: skip when Desktop not running | commit `38b3e87` |
| — | Agents.md / CLAUDE.md / copilot-instructions.md — natural language, no AI speak | done |
| — | Navi as submodule | `modules/` has navi integration |

---

## Dropped / Out of Scope

| ID | Title | Reason |
|----|-------|--------|
| P015 | Cloud CLI helpers (AWS/GCP/Azure) | Too broad, external deps heavy |
| P016 | Database connection manager | Out of scope for personal dotfiles |
| P017 | AI helper integration | Claude Code covers this |
| P023 | Fish/PowerShell support | High effort, low personal value |
| P026 | Clipboard manager | Desktop only, not relevant |
| P027 | Password manager CLI | Out of scope |
| P028 | Weather widget | curl wttr.in alias covers this |
| P029 | Calendar integration | Out of scope |

---

## Quick Wins (< 1h each)

| Effort | Task | File(s) |
|--------|------|---------|
| 30 min | IMP-002: remove hardcoded username | `bashrc:208`, `zshrc:196` |
| 30 min | IMP-001: add `[[ -f ]]` before ioBroker source | `bashrc:209-210`, `zshrc:197-198` |
| 1h | IMP-005: fix IPv6 in tmux rename regex | `bashrc:195`, `zshrc` |
| 1h | IMP-016: `set -euo pipefail` in install.sh | `install.sh` |
| 1h | IMP-006: Docker daemon-down detection | `motd/widgets.sh:87` |
