# 📋 Backlog

![open](https://img.shields.io/badge/open-50-blue) ![done](https://img.shields.io/badge/done-14-brightgreen) ![dropped](https://img.shields.io/badge/dropped-8-lightgrey)

Note: entries are never removed from this backlog, only status changes (done, out-of-scope, etc.).

Last bug scan: 2026-09-07 (shellcheck 0.9.0 + `bash -n` + manual review of `bashrc`, `zshrc`, `components/`, `motd/`, `install.sh`, `autoupdate.sh`).

**Status:** 🔲 `open` · 🚧 `in-progress` · ✅ `done` · ⛔ `dropped`
**Priority:** 🔴 High · 🟡 Medium · 🟢 Low
**Type:** 🆕 `NEW-*` New-Feature · 🐛 `BUG-*` Bug · 🔒 `SEC-*` Security · ⚡ `PER-*` Performance · 📄 `DOC-*` Chore/Docs

---

## 🔴 High Priority

| ID      | Title                                                                                                         | Type        | Status  | Notes                                                              |
|---------|---------------------------------------------------------------------------------------------------------------|-------------|---------|--------------------------------------------------------------------|
| BUG-001 | ioBroker source validation — add `[[ -f ]]` check before sourcing `~/.iobroker/*` files in `bashrc`, `zshrc`  | 🐛 Bug      | ✅ done [`696b410`](https://github.com/darkiop/dotfiles/commit/696b410) | 30 min                                                             |
| SEC-001 | Move WOL MAC addresses out of `alias/alias:310-314` into encrypted config or env vars                         | 🔒 Security | 🔲 open | security                                                           |
| SEC-002 | Secret scanning — pre-commit hook via gitleaks/trufflehog + `dot secrets-scan`, whitelist for false positives | 🔒 Security | 🔲 open | `components/secret_scanner`, flag `DOTFILES_ENABLE_SECRET_SCANNER` |
| SEC-003 | `install.sh:52-56` pipes remote `dotfiles.config` into `source <(curl -s ...)` with no failure or integrity check | 🔒 Security | ✅ done [`819b4fb`](https://github.com/darkiop/dotfiles/commit/819b4fb) | a 404/HTML body or MITM response gets executed; `set -e` does not catch process-substitution failure. Fetch to a temp file, check HTTP status, then source |
| BUG-006 | `components/platform:22` runs `source /etc/os-release`, leaking every one of its variables into the interactive shell | 🐛 Bug      | ✅ done [`8f9940e`](https://github.com/darkiop/dotfiles/commit/8f9940e) | verified: `NAME`, `VERSION`, `VERSION_ID`, `PRETTY_NAME`, `HOME_URL`, `LOGO`, … are all set in every shell. Parse `ID`/`ID_LIKE` with `grep`/`awk`, or source inside a subshell |
| BUG-007 | `motd/motd-odin.sh:8` is a bash syntax error — unescaped `($volume1_usage%)` outside quotes                   | 🐛 Bug      | ✅ done [`d5a5df4`](https://github.com/darkiop/dotfiles/commit/d5a5df4) | `bash -n motd/motd-odin.sh` fails; file never executes. Also dead code (see BUG-008) — fix or delete |
| BUG-002 | Docker widget: distinguish "daemon not running" from "0 containers" in `motd/widgets.sh:97-99`                | 🐛 Bug      | ✅ done [`07b535f`](https://github.com/darkiop/dotfiles/commit/07b535f) | confirmed: exit status comes from the trailing `wc -l`, so `if ! running=$(... \| wc -l ...)` never fires. Check `docker info` first, show widget on 0 containers too |

---

## 🟡 Medium Priority

### 🐛 Bugs

| ID      | Title                                                                                                      | Type   | Status  | Ref                                                                                                                                                                   |
|---------|--------------------------------------------------------------------------------------------------------------|--------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BUG-008 | MOTD hostname routing does not exist — `motd-odin.sh` / `motd-proxmox.sh` are never sourced                | 🐛 Bug | 🔲 open | Deferred 2026-09-07: needs a decision — wire up routing or drop the per-host files. `bashrc:115`, `zshrc:126` source `motd/motd-catppuccin-mocha.sh` directly. `motd.sh` special-cases `odin` inline instead of dispatching. Either wire up routing or drop the per-host files |
| BUG-009 | `motd` alias bypasses the color wrapper                                                                    | 🐛 Bug | 🔲 open | Deferred 2026-09-07: depends on the BUG-008 decision (which file is the entry point). `alias/alias:225` is `source ~/dotfiles/motd/motd.sh`, but login MOTD goes through `motd-catppuccin-mocha.sh`. Manual invocation renders with different colors, and `source` leaks `HOSTNAME`/`USAGE_*`/`_motd_*` into the shell |
| BUG-010 | Host widget directory lookup uses the full hostname, not the short one                                     | 🐛 Bug | ✅ done [`a52a68c`](https://github.com/darkiop/dotfiles/commit/a52a68c) | `motd/widgets.sh` `motd_run_widgets` does `hostname=$(hostname)`; on an FQDN host `motd/widgets/<fqdn>/` never matches. `motd.sh` already computes `HOSTNAME_SHORT` — reuse it |
| BUG-011 | `DOTFILES_ENABLE_NETWORK_WIDGET` is documented but missing from `components/feature_flags`                 | 🐛 Bug | 🔲 open | README.md:138 documents it; the flag is never defaulted, normalized, or exported. `motd/widgets.sh:6` compensates by re-sourcing `local_dotfiles_settings` mid-render. Add it to the flag list and the cache array, then drop the workaround |
| BUG-012 | `autoupdate.sh` retries a network `git pull` on every shell start after one failure                        | 🐛 Bug | 🔲 open | `autoupdate.sh:52` resets the counter only when the subshell exits 0. A failed pull leaves the count above 20, so every subsequent shell blocks on the network. Reset (or back off) on failure too, and add a timeout |
| BUG-015 | `motd/motd.sh` tree renderer needs bash 4+ (`local -A category_items`)                                     | 🐛 Bug | 🔲 open | breaks on stock macOS bash 3.2, the default `DOTFILES_MOTD_STYLE=tree`. Guard on `BASH_VERSINFO` and fall back to `default` style, or replace the associative array |
| BUG-018 | `ADD_TO_PATH` appends, so personal bin dirs rank below system paths                                        | 🐛 Bug | 🔲 open | `bashrc:20-26`, `zshrc:24-30`. Verified: `~/bin`, `~/.local/bin`, `~/.cargo/bin` end up after `/usr/bin`, so user-installed tools cannot shadow system ones. Overlaps DOC-004 |

### ⚡ Performance

| ID      | Title                                                                   | Type           | Status                                                                  |
|---------|-------------------------------------------------------------------------|----------------|-------------------------------------------------------------------------|
| NEW-001 | `dot profile` — shell startup profiler, measure load time per component | 🆕 New-Feature | ✅ done [`2b798df`](https://github.com/darkiop/dotfiles/commit/2b798df) |
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
| DOC-016 | Remove dead prompt components: `components/bash_prompt` and `components/bash_prompt_catppuccin_mocha_2`          | 📄 Chore | 🔲 open |
| DOC-018 | `bin/archive/*` is tracked in git although `.gitignore` lists it — 8 legacy scripts, ~50 shellcheck warnings     | 📄 Chore | 🔲 open |
| DOC-019 | `dot doctor` has no inline component fallback, unlike `dot profile` (`components/dot_help:404` vs `:409-422`)    | 📄 Chore | 🔲 open |

### 📚 Docs

| ID      | Title                                                                                  | Type     | Status  |
|---------|----------------------------------------------------------------------------------------|----------|---------|
| DOC-017 | Doc drift in AGENTS.md / CLAUDE.md / copilot-instructions.md — see notes below          | 📄 Chore | 🔲 open |
| DOC-007 | Architecture diagram — loading order visualization in README.md                        | 📄 Chore | 🔲 open |
| DOC-008 | Troubleshooting guide — slow startup, macOS bash 3.2, WSL gotchas, container detection | 📄 Chore | 🔲 open |
| DOC-009 | Compatibility matrix — bash 4+/zsh 5.0+, macOS vs Linux, container limits              | 📄 Chore | 🔲 open |

**DOC-017 details** — the three agent instruction files drifted from the code (keep all three in sync):

- Component count says 22; there are 26 in `components/`.
- Component table is missing `dot_profile`, `lazy_loader`, `log_picker`, `bash_prompt_catppuccin_mocha`.
- Component table still lists `bash_prompt`, which `bashrc` no longer sources (see DOC-016).
- Flag table is missing `DOTFILES_ENABLE_LAZY_LOADING`, `DOTFILES_ENABLE_LOG_PICKER`, `DOTFILES_ENABLE_NETWORK_WIDGET`, `DOTFILES_MOTD_STYLE`.
- MOTD section describes `motd/motd.sh` as a hostname router; it is not one (see BUG-008).
- Loading order block omits the lazy-loading branch in `bashrc`/`zshrc`.

---

## 🟢 Low Priority

### 🐛 Bugs & Papercuts

| ID      | Title                                                                                           | Type   | Status  | Ref                                                                                                                        |
|---------|---------------------------------------------------------------------------------------------------|--------|---------|-------------------------------------------------------------------------------------------------------------------------------|
| BUG-013 | `motd/motd.sh:85` assigns `HOSTNAME=$(hostname)`, clobbering the shell's own `HOSTNAME`         | 🐛 Bug | 🔲 open | `motd.sh` is sourced (not executed) from `bashrc`/`zshrc`. Rename to `MOTD_HOSTNAME`                                        |
| BUG-014 | `motd/motd.sh:169` reads `${MOTD_SHOW_APT_UPDATES}` with no `:-` default                        | 🐛 Bug | 🔲 open | unset when `motd.sh` runs standalone; blocks DOC-003 (`set -u`). Every other read in the file already uses `:-`             |
| BUG-016 | `components/lazy_loader:42` uses loop variable `f` before the `local f` on line 55              | 🐛 Bug | 🔲 open | the first `for f in "${extra_funcs[@]}"` clobbers a global `$f`. Move the declaration above the loop                        |
| BUG-017 | `tput sgr0` called without error suppression                                                    | 🐛 Bug | 🔲 open | `config/dotfiles.config:19`, `motd/motd.sh:143` — stderr noise on unset/dumb `TERM`. `motd.sh:17` already does it correctly |
| BUG-019 | `motd/motd.sh:113` `cat /etc.defaults/VERSION` on the `odin` branch without an existence check   | 🐛 Bug | 🔲 open | any host named `odin` that is not a Synology NAS prints a `cat` error into the MOTD                                        |
| BUG-020 | `shopt` guard in `components/lazy_loader:34,64` is a silent no-op under zsh                     | 🐛 Bug | 🔲 open | `shopt` does not exist in zsh; the `unalias` on line 41 is what actually protects zsh. Gate the block on `${BASH_VERSION}`  |

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
| BUG-001 | ioBroker source validation — `[[ -f ]]` check before sourcing `~/.iobroker/*`   | 🐛 Bug         | [`696b410`](https://github.com/darkiop/dotfiles/commit/696b410) | guards in `bashrc` + `zshrc`                               |
| BUG-003 | Remove hardcoded `$USER == "darkiop"` check                                     | 🐛 Bug         | [`4cf440d`](https://github.com/darkiop/dotfiles/commit/4cf440d) | `DOTFILES_ENABLE_IOBROKER` flag + binary check gate it now |
| BUG-004 | Fix IPv6 detection in SSH tmux rename regex                                     | 🐛 Bug         | [`19f0455`](https://github.com/darkiop/dotfiles/commit/19f0455) |                                                            |
| PER-002 | Lazy-load rarely used components — wrapper registers on first call              | ⚡ Performance | [`bb38295`](https://github.com/darkiop/dotfiles/commit/bb38295) | `components/lazy_loader`                                   |
| PER-001 | Feature-flag caching — compute flags once at startup, not 40+ times             | ⚡ Performance | [`7d9276c`](https://github.com/darkiop/dotfiles/commit/7d9276c) |                                                            |
| NEW-020 | Systemd unit manager with fzf                                                   | 🆕 New-Feature | [`eeedc1b`](https://github.com/darkiop/dotfiles/commit/eeedc1b) | `components/fzf_systemctl` exists                          |
| BUG-005 | Docker widget macOS: skip when Desktop not running                              | 🐛 Bug         | [`38b3e87`](https://github.com/darkiop/dotfiles/commit/38b3e87) |                                                            |
| DOC-015 | AGENTS.md / CLAUDE.md / copilot-instructions.md — natural language, no AI speak | 📄 Chore       | [`60efee1`](https://github.com/darkiop/dotfiles/commit/60efee1) |                                                            |
| NEW-001 | `dot profile` — shell startup profiler                                          | 🆕 New-Feature | [`2b798df`](https://github.com/darkiop/dotfiles/commit/2b798df) | `components/dot_profile`, `dot profile\|prof`; needs docs (DOC-017) |
| SEC-003 | install.sh: verify remote config download before sourcing                       | 🔒 Security | [`819b4fb`](https://github.com/darkiop/dotfiles/commit/819b4fb) | temp file + `--fail`/`--proto '=https'`; content pinning still open |
| BUG-002 | Docker widget: tell a stopped daemon apart from zero containers                 | 🐛 Bug      | [`07b535f`](https://github.com/darkiop/dotfiles/commit/07b535f) | exit status was swallowed by `wc -l`                       |
| BUG-006 | Stop leaking `/etc/os-release` variables into the shell                         | 🐛 Bug      | [`8f9940e`](https://github.com/darkiop/dotfiles/commit/8f9940e) | `components/platform` reads ID/ID_LIKE in a subshell       |
| BUG-007 | Repair the syntax error in `motd/motd-odin.sh`                                  | 🐛 Bug      | [`d5a5df4`](https://github.com/darkiop/dotfiles/commit/d5a5df4) | file never executed before; still unrouted (BUG-008)       |
| BUG-010 | Host widget lookup uses the short hostname                                      | 🐛 Bug      | [`a52a68c`](https://github.com/darkiop/dotfiles/commit/a52a68c) | FQDN dir name still honoured as a fallback                 |

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

| Effort | Task                                          | Type           | File(s)                                     |
|--------|-----------------------------------------------|----------------|---------------------------------------------|
| 10 min | BUG-014: default `MOTD_SHOW_APT_UPDATES`      | 🐛 Bug         | `motd/motd.sh:169`                          |
| 10 min | BUG-016: move `local f` above the loop        | 🐛 Bug         | `components/lazy_loader:42,55`              |
| 10 min | BUG-017: suppress `tput sgr0` errors          | 🐛 Bug         | `config/dotfiles.config:19`, `motd/motd.sh:143` |
| 15 min | BUG-011: declare `DOTFILES_ENABLE_NETWORK_WIDGET` | 🐛 Bug     | `components/feature_flags`                  |
| 15 min | BUG-013: rename MOTD `HOSTNAME`               | 🐛 Bug         | `motd/motd.sh:85`                           |
| 30 min | DOC-016: delete dead prompt components        | 📄 Chore       | `components/bash_prompt*`                   |
| 1h     | DOC-003: `set -euo pipefail` in motd scripts  | 📄 Chore       | `motd/motd.sh`, `motd/widgets.sh`           |
| 1h     | NEW-019: `DOTFILES_WSL_VERSION` detection     | 🆕 New-Feature | `components/platform`                       |
| 1h     | DOC-014: macOS bash upgrade guide             | 📄 Chore       | `README.md`                                 |
