# 📋 Backlog

![open](https://img.shields.io/badge/open-36-blue) ![done](https://img.shields.io/badge/done-7-brightgreen) ![dropped](https://img.shields.io/badge/dropped-8-lightgrey)

Note: entries are never removed from this backlog, only status changes (done, out-of-scope, etc.).

**Status:** 🔲 `open` · 🚧 `in-progress` · ✅ `done` · ⛔ `dropped`
**Priority:** 🔴 High · 🟡 Medium · 🟢 Low
**Type:** 🆕 `NEW-*` New-Feature · 🐛 `BUG-*` Bug · 🔒 `SEC-*` Security · ⚡ `PER-*` Performance · 📄 `DOC-*` Chore/Docs

---

## 🔴 High Priority

| ID      | Title                                                                                                         | Type        | Status  | Notes                                                              |
|---------|---------------------------------------------------------------------------------------------------------------|-------------|---------|--------------------------------------------------------------------|
| BUG-001 | ioBroker source validation — add `[[ -f ]]` check before sourcing `~/.iobroker/*` files in `bashrc`, `zshrc`  | 🐛 Bug      | ✅ done | 30 min                                                             |
| SEC-001 | Move WOL MAC addresses out of `alias/alias:310-314` into encrypted config or env vars                         | 🔒 Security | 🔲 open | security                                                           |
| SEC-002 | Secret scanning — pre-commit hook via gitleaks/trufflehog + `dot secrets-scan`, whitelist for false positives | 🔒 Security | 🔲 open | `components/secret_scanner`, flag `DOTFILES_ENABLE_SECRET_SCANNER` |
| BUG-002 | Docker widget: distinguish "daemon not running" from "0 containers" in `motd/widgets.sh:97-99`                | 🐛 Bug      | 🔲 open | check `docker info` first, show widget on 0 containers too         |

---

## 🟡 Medium Priority

### ⚡ Performance

| ID      | Title                                                                   | Type           | Status                                                                  |
|---------|-------------------------------------------------------------------------|----------------|-------------------------------------------------------------------------|
| NEW-001 | `dot profile` — shell startup profiler, measure load time per component | 🆕 New-Feature | 🔲 open                                                                 |
| PER-001 | Feature-flag caching — compute flags once at startup, not 40+ times     | ⚡ Performance | ✅ done [`7d9276c`](https://github.com/darkiop/dotfiles/commit/7d9276c) |

### ✨ Features

| ID      | Title                                                                                                                                                               | Type           | Status  | Ref                                                                                                 |
|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------|-----------------------------------------------------------------------------------------------------|
| NEW-002 | Directory bookmarks — `mark`, `jump`, `unmark`, `marks` commands, storage in `~/.dotfiles_bookmarks`                                                                | 🆕 New-Feature | 🔲 open | `components/bookmarks`, flag `DOTFILES_ENABLE_BOOKMARKS`                                            |
| NEW-003 | Process manager — `psfzf` interactive process picker with kill/nice/renice/info                                                                                     | 🆕 New-Feature | 🔲 open | `components/fzf_process`, flag `DOTFILES_ENABLE_PROCESS_FZF`                                        |
| NEW-004 | Installer dry-run — `install.sh --dry-run` preview mode, progress + rollback on error                                                                               | 🆕 New-Feature | 🔲 open |                                                                                                     |
| DOC-001 | Navi as proper git submodule (`modules/navi/`) analogous to fzf/oh-my-zsh, with `install` script                                                                    | 📄 Chore       | 🔲 open | flag `DOTFILES_ENABLE_NAVI` already exists; currently vendored via `cheats/`, not `modules/`        |
| DOC-002 | MOTD standard lines (hostname, uptime, last login) migrated into widget system for consistent config                                                                | 📄 Chore       | 🔲 open |                                                                                                     |
| NEW-005 | kubectl fzf helpers — `kpods`, `klogs`, `kexec`, `kdesc`, `kctx`, `kns`                                                                                             | 🆕 New-Feature | 🔲 open | `components/fzf_kubectl`, flag `DOTFILES_ENABLE_KUBECTL_FZF`                                        |
| NEW-006 | Extended git helpers — `gwip`, `gundo`, `gclean`, `gworktree`, `gbrowse`, `gblame-fzf`                                                                              | 🆕 New-Feature | 🔲 open | extend `components/fzf_git`                                                                         |
| NEW-007 | Config validator — `dot validate`: shellcheck integration, syntax check all shell files, flag-typo detection, deprecated-feature detection, broken-source-ref check | 🆕 New-Feature | 🔲 open | extends `components/dot_doctor` (symlink check already in `dot_doctor`); merged with former IMP-025 |
| NEW-008 | Audit log — `dot audit`, logs installs/updates/config changes with timestamp/operation/user/outcome                                                                 | 🆕 New-Feature | 🔲 open | `components/audit_log`, flag `DOTFILES_ENABLE_AUDIT_LOG`                                            |
| NEW-009 | FZF preview enhancements — bat syntax highlighting, dynamic sizing, image preview, shared preview helpers                                                           | 🆕 New-Feature | 🔲 open |                                                                                                     |

### 🧹 Code Quality

| ID      | Title                                                                                                            | Type     | Status  |
|---------|------------------------------------------------------------------------------------------------------------------|----------|---------|
| DOC-003 | Add `set -euo pipefail` to `motd/motd.sh`, `motd/widgets.sh`, widget scripts (`install.sh` already has `set -e`) | 📄 Chore | 🔲 open |
| DOC-004 | Array-based PATH management in bashrc/zshrc instead of repeated `ADD_TO_PATH` calls                              | 📄 Chore | 🔲 open |
| DOC-005 | Split `components/fzf` (166 lines) into `fzf_core` + `fzf_tab_completion`                                        | 📄 Chore | 🔲 open |
| DOC-006 | Shellcheck audit — review 36 suppressions in 13 files, reduce SC2312/SC2086/SC1090                               | 📄 Chore | 🔲 open |

### 📚 Docs

| ID      | Title                                                                                  | Type     | Status  |
|---------|----------------------------------------------------------------------------------------|----------|---------|
| DOC-007 | Architecture diagram — loading order visualization in README.md                        | 📄 Chore | 🔲 open |
| DOC-008 | Troubleshooting guide — slow startup, macOS bash 3.2, WSL gotchas, container detection | 📄 Chore | 🔲 open |
| DOC-009 | Compatibility matrix — bash 4+/zsh 5.0+, macOS vs Linux, container limits              | 📄 Chore | 🔲 open |

---

## 🟢 Low Priority

### 🗂️ Organization

| ID      | Title                                                                                                           | Type           | Status  |
|---------|-----------------------------------------------------------------------------------------------------------------|----------------|---------|
| DOC-010 | Split `alias/alias` (372 lines) into `alias-core`, `alias-system`, `alias-dev`                                  | 📄 Chore       | 🔲 open |
| DOC-011 | Reorganize 57 cheat files into `cheats/docker/`, `cheats/git/`, `cheats/kubernetes/`                            | 📄 Chore       | 🔲 open |
| NEW-010 | Docker output colorizer — optionally integrate better-docker-ps or docker-color-output                          | 🆕 New-Feature | 🔲 open |
| NEW-011 | Snippet manager — `snip add/run/list/edit/delete`, template vars (`{{var}}`), fzf picker                        | 🆕 New-Feature | 🔲 open |
| NEW-012 | History insights — `dot stats`, top-20 commands, alias suggestions, unused-feature detection                    | 🆕 New-Feature | 🔲 open |
| NEW-013 | Network tools — `netfzf` (ports + process info), `curlfzf` (saved HTTP requests), `sshfzf` (active connections) | 🆕 New-Feature | 🔲 open |
| NEW-014 | File finder — `ff [pattern]` with bat preview, actions, ripgrep full-text search, .gitignore support            | 🆕 New-Feature | 🔲 open |
| NEW-015 | Note-taking system — `note`, `note search`, markdown + tags, storage in `~/.notes/`                             | 🆕 New-Feature | 🔲 open |

### 🏗️ Architecture

| ID      | Title                                                                                                  | Type           | Status  |
|---------|--------------------------------------------------------------------------------------------------------|----------------|---------|
| NEW-016 | Plugin system — `plugins/` dir with auto-discovery for user extensions                                 | 🆕 New-Feature | 🔲 open |
| NEW-017 | Environment switcher — `dotenv list/switch/current`, cloud profile integration                         | 🆕 New-Feature | 🔲 open |
| NEW-018 | Remote host manager — enhanced ssh_picker with metadata, tags, tunnels, storage in `config/hosts.json` | 🆕 New-Feature | 🔲 open |

### 🧪 Testing & CI

| ID      | Title                                                         | Type     | Status  |
|---------|---------------------------------------------------------------|----------|---------|
| DOC-012 | GitHub Actions CI — shellcheck validation on push             | 📄 Chore | 🔲 open |
| DOC-013 | BATS test suite — component loading, feature flags, FZF, MOTD | 📄 Chore | 🔲 open |

### 🖥️ Compatibility

| ID      | Title                                                                                                | Type           | Status  |
|---------|------------------------------------------------------------------------------------------------------|----------------|---------|
| NEW-019 | Add `DOTFILES_WSL_VERSION` (1 or 2) to platform detection, alongside existing boolean `DOTFILES_WSL` | 🆕 New-Feature | 🔲 open |
| DOC-014 | macOS bash upgrade guide in README.md (bash 4+ for FZF tab completion)                               | 📄 Chore       | 🔲 open |

---

## ✅ Done

| ID      | Title                                                                           | Type           | Commit                                                          | Notes                                                      |
|---------|---------------------------------------------------------------------------------|----------------|-----------------------------------------------------------------|------------------------------------------------------------|
| BUG-001 | ioBroker source validation — `[[ -f ]]` check before sourcing `~/.iobroker/*`   | 🐛 Bug         | —                                                               | guards in `bashrc` + `zshrc`                               |
| BUG-003 | Remove hardcoded `$USER == "darkiop"` check                                     | 🐛 Bug         | [`4cf440d`](https://github.com/darkiop/dotfiles/commit/4cf440d) | `DOTFILES_ENABLE_IOBROKER` flag + binary check gate it now |
| BUG-004 | Fix IPv6 detection in SSH tmux rename regex                                     | 🐛 Bug         | [`19f0455`](https://github.com/darkiop/dotfiles/commit/19f0455) |                                                            |
| PER-002 | Lazy-load rarely used components — wrapper registers on first call              | ⚡ Performance | [`bb38295`](https://github.com/darkiop/dotfiles/commit/bb38295) | `components/lazy_loader`                                   |
| PER-001 | Feature-flag caching — compute flags once at startup, not 40+ times             | ⚡ Performance | [`7d9276c`](https://github.com/darkiop/dotfiles/commit/7d9276c) |                                                            |
| NEW-020 | Systemd unit manager with fzf                                                   | 🆕 New-Feature | [`eeedc1b`](https://github.com/darkiop/dotfiles/commit/eeedc1b) | `components/fzf_systemctl` exists                          |
| BUG-005 | Docker widget macOS: skip when Desktop not running                              | 🐛 Bug         | [`38b3e87`](https://github.com/darkiop/dotfiles/commit/38b3e87) |                                                            |
| DOC-015 | AGENTS.md / CLAUDE.md / copilot-instructions.md — natural language, no AI speak | 📄 Chore       | [`60efee1`](https://github.com/darkiop/dotfiles/commit/60efee1) |                                                            |

---

## ⛔ Dropped / Out of Scope

| ID      | Title                                      | Type           | Reason                                      |
|---------|--------------------------------------------|----------------|---------------------------------------------|
| NEW-021 | Cloud CLI helpers (AWS/GCP/Azure)          | 🆕 New-Feature | Too broad, external deps heavy              |
| NEW-022 | Database connection manager                | 🆕 New-Feature | Out of scope for personal dotfiles          |
| NEW-023 | AI helper integration                      | 🆕 New-Feature | Claude Code covers this                     |
| NEW-024 | Fish/PowerShell support (incl. oh-my-posh) | 🆕 New-Feature | High effort, low personal value             |
| NEW-025 | Clipboard manager                          | 🆕 New-Feature | Desktop only, not relevant                  |
| NEW-026 | Password manager CLI                       | 🆕 New-Feature | Out of scope                                |
| NEW-027 | Weather widget                             | 🆕 New-Feature | Fun-only, not core to a shell dotfiles repo |
| NEW-028 | Calendar integration                       | 🆕 New-Feature | Out of scope                                |

---

## 🚀 Quick Wins (< 1h each)

| Effort | Task                                         | Type           | File(s)                           |
|--------|----------------------------------------------|----------------|-----------------------------------|
| 1h     | DOC-003: `set -euo pipefail` in motd scripts | 📄 Chore       | `motd/motd.sh`, `motd/widgets.sh` |
| 1h     | BUG-002: Docker daemon-down detection        | 🐛 Bug         | `motd/widgets.sh:97-99`           |
| 1h     | NEW-019: `DOTFILES_WSL_VERSION` detection    | 🆕 New-Feature | `components/platform`             |
| 1h     | DOC-014: macOS bash upgrade guide            | 📄 Chore       | `README.md`                       |
