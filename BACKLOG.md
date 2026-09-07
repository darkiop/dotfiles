# 📋 Backlog

![open](https://img.shields.io/badge/open-35-blue) ![done](https://img.shields.io/badge/done-32-brightgreen) ![dropped](https://img.shields.io/badge/dropped-8-lightgrey)

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
| SEC-004 | `install.sh` bootstrap fetches `dotfiles.config` without verifying its content | 🔒 Security | 🔲 open | follow-up to SEC-003 ([`819b4fb`](https://github.com/darkiop/dotfiles/commit/819b4fb)): the transfer is now checked (HTTP status, TLS, timeout), but a compromised repo or raw host still delivers executable shell. Pin a SHA-256 of the config in `install.sh` and refuse to source on mismatch |
| BUG-006 | `components/platform:22` runs `source /etc/os-release`, leaking every one of its variables into the interactive shell | 🐛 Bug      | ✅ done [`8f9940e`](https://github.com/darkiop/dotfiles/commit/8f9940e) | verified: `NAME`, `VERSION`, `VERSION_ID`, `PRETTY_NAME`, `HOME_URL`, `LOGO`, … are all set in every shell. Parse `ID`/`ID_LIKE` with `grep`/`awk`, or source inside a subshell |
| BUG-007 | `motd/motd-odin.sh:8` is a bash syntax error — unescaped `($volume1_usage%)` outside quotes                   | 🐛 Bug      | ✅ done [`d5a5df4`](https://github.com/darkiop/dotfiles/commit/d5a5df4) | `bash -n motd/motd-odin.sh` fails; file never executes. Also dead code (see BUG-008) — fix or delete |
| BUG-002 | Docker widget: distinguish "daemon not running" from "0 containers" in `motd/widgets.sh:97-99`                | 🐛 Bug      | ✅ done [`07b535f`](https://github.com/darkiop/dotfiles/commit/07b535f) | confirmed: exit status comes from the trailing `wc -l`, so `if ! running=$(... \| wc -l ...)` never fires. Check `docker info` first, show widget on 0 containers too |

---

## 🟡 Medium Priority

### 🐛 Bugs

| ID      | Title                                                                                                      | Type   | Status  | Ref                                                                                                                                                                   |
|---------|--------------------------------------------------------------------------------------------------------------|--------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BUG-008 | MOTD hostname routing does not exist — `motd-odin.sh` / `motd-proxmox.sh` are never sourced                | 🐛 Bug | ✅ done [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40) | resolved by converting both files into widgets instead of adding a router. Original note: needs a decision — wire up routing or drop the per-host files. `bashrc:115`, `zshrc:126` source `motd/motd-catppuccin-mocha.sh` directly. `motd.sh` special-cases `odin` inline instead of dispatching. Either wire up routing or drop the per-host files |
| BUG-009 | `motd` alias bypasses the color wrapper                                                                    | 🐛 Bug | ✅ done [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40) | alias and login MOTD both run `motd-catppuccin-mocha.sh` in a child shell now. Original note: depends on the BUG-008 decision (which file is the entry point). `alias/alias:225` is `source ~/dotfiles/motd/motd.sh`, but login MOTD goes through `motd-catppuccin-mocha.sh`. Manual invocation renders with different colors, and `source` leaks `MOTD_HOSTNAME`/`USAGE_*`/`_motd_*` into the shell |
| BUG-010 | Host widget directory lookup uses the full hostname, not the short one                                     | 🐛 Bug | ✅ done [`a52a68c`](https://github.com/darkiop/dotfiles/commit/a52a68c) | `motd/widgets.sh` `motd_run_widgets` does `hostname=$(hostname)`; on an FQDN host `motd/widgets/<fqdn>/` never matches. `motd.sh` already computes `HOSTNAME_SHORT` — reuse it |
| BUG-011 | `DOTFILES_ENABLE_NETWORK_WIDGET` is documented but missing from `components/feature_flags`                 | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | README.md:138 documents it; the flag is never defaulted, normalized, or exported. `motd/widgets.sh:6` compensates by re-sourcing `local_dotfiles_settings` mid-render. Add it to the flag list and the cache array, then drop the workaround |
| BUG-012 | `autoupdate.sh` retries a network `git pull` on every shell start after one failure                        | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | `autoupdate.sh:52` resets the counter only when the subshell exits 0. A failed pull leaves the count above 20, so every subsequent shell blocks on the network. Reset (or back off) on failure too, and add a timeout |
| BUG-015 | `motd/motd.sh` tree renderer needs bash 4+ (`local -A category_items`)                                     | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | breaks on stock macOS bash 3.2, the default `DOTFILES_MOTD_STYLE=tree`. Guard on `BASH_VERSINFO` and fall back to `default` style, or replace the associative array |
| BUG-018 | `ADD_TO_PATH` appends, so personal bin dirs rank below system paths                                        | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | `bashrc:20-26`, `zshrc:24-30`. Verified: `~/bin`, `~/.local/bin`, `~/.cargo/bin` end up after `/usr/bin`, so user-installed tools cannot shadow system ones. Overlaps DOC-004 |
| BUG-022 | `COLOR_SUCCESS` reaches the widgets as the literal text `\e[38;2;166;227;161m` | 🐛 Bug | 🔲 open | `motd/motd-catppuccin-mocha.sh:20` builds the palette with `"\e[..."` strings, which `motd.sh` resolves with `printf %b`. The three widgets that colorize their own output (`_motd_widget_proxmox_ids`, `_motd_widget_proxmox_services`, `_motd_widget_network` in `motd/widgets.sh:278,360,497`) print with `%s` instead and default their red to `$'\x1b[...'`, so a reachable host renders as `\e[38;2;166;227;161mudmp\e[m` while an unreachable one is colored correctly. Reproduced on `pve-ct-dev`. Assign `COLOR_SUCCESS` with `$'\x1b[38;2;166;227;161m'` in the wrapper (the other `COLOR_*` vars must stay `\e`-escaped for their `%b` consumers) |
| BUG-021 | `motd/widgets.sh:536` uses `declare -A _motd_cmd_available`, so command gating breaks on bash 3.2 | 🐛 Bug | ✅ done [`406b355`](https://github.com/darkiop/dotfiles/commit/406b355) | replaced by a `:`-delimited string plus a `case` test in `_motd_has_cmd`. Original note: same class as BUG-015 ([`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)), which only covered `motd.sh`. The `declare` is guarded with `2>/dev/null || true`, so on stock macOS bash 3.2 it silently stays an indexed array: every string subscript evaluates to 0, `_motd_cmd_available[docker]=1` writes index 0, and `_motd_has_cmd <anything>` then returns true. Reproduced: `x[docker]=1` makes `${x[nonexistent]}` read `1`. Consequence: every built-in widget runs on every login even when its tool is missing. Replace the map with a delimited string plus a `case` test |

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
| DOC-003 | Add `set -euo pipefail` to `motd/motd.sh`, `motd/widgets.sh`, widget scripts (`install.sh` already has `set -e`) | 📄 Chore | ✅ done [`d8ec7c9`](https://github.com/darkiop/dotfiles/commit/d8ec7c9) |
| DOC-004 | Array-based PATH management in bashrc/zshrc instead of repeated `ADD_TO_PATH` calls                              | 📄 Chore | 🔲 open |
| DOC-005 | Split `components/fzf` (166 lines) into `fzf_core` + `fzf_tab_completion`                                        | 📄 Chore | 🔲 open |
| DOC-006 | Shellcheck audit — review 36 suppressions in 13 files, reduce SC2312/SC2086/SC1090                               | 📄 Chore | 🔲 open |
| DOC-016 | Remove dead prompt components: `components/bash_prompt` and `components/bash_prompt_catppuccin_mocha_2`          | 📄 Chore | ✅ done [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40) |
| DOC-018 | `bin/archive/*` is tracked in git although `.gitignore` lists it — 8 legacy scripts, ~50 shellcheck warnings     | 📄 Chore | 🔲 open |
| DOC-019 | `dot doctor` has no inline component fallback, unlike `dot profile` (`components/dot_help:404` vs `:409-422`)    | 📄 Chore | 🔲 open |

### 📚 Docs

| ID      | Title                                                                                  | Type     | Status  |
|---------|----------------------------------------------------------------------------------------|----------|---------|
| DOC-017 | Doc drift in AGENTS.md / CLAUDE.md / copilot-instructions.md — see notes below          | 📄 Chore | ✅ done [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40) |
| DOC-007 | Architecture diagram — loading order visualization in README.md                        | 📄 Chore | 🔲 open |
| DOC-008 | Troubleshooting guide — slow startup, macOS bash 3.2, WSL gotchas, container detection | 📄 Chore | 🔲 open |
| DOC-009 | Compatibility matrix — bash 4+/zsh 5.0+, macOS vs Linux, container limits              | 📄 Chore | 🔲 open |

**DOC-003 details** — `set -euo pipefail` now heads `motd/motd.sh`, `motd/widgets.sh`, the three host widget scripts that lacked it and `motd/systemd/calc-dir-size-homes.sh`. Both MOTD entry points already run in their own `bash` process (BUG-009), so the strict mode never reaches the interactive shell. Hardened alongside it, because `pipefail` and `set -u` would otherwise abort a login banner mid-render:

- `grep -c` exits 1 when it counts zero — it fed `_motd_count_lines` (docker widget) and `iobroker-updates.sh`; both now tolerate it.
- `iobroker-status.sh` used `grep -c ... || echo "0"`, which printed *two* lines (`0\n0`) whenever no instance was enabled. Fixed with `|| true` plus a `:-0` default.
- Empty arrays (`_docker_env`, `instances`) are unbound references under `set -u` on bash < 4.4, so they are now guarded; `_motd_widget_proxmox_ids` returns 1 on an empty list instead of printing a bare color escape.
- Optional-tool pipelines (`tailscale`, `wg`, `pveversion`, `brew`, `inxi`, `toilet`, `jq`, `sysctl`, `hostname`, `du`) end in `|| true`, and `motd_run_widgets` is called with `|| true`.

**DOC-017 details** — all six drift points are fixed; the three files are byte-identical apart from their own filename references:

- ~~Component count says 22~~ → now 24, matching `components/` after DOC-016.
- ~~Component table is missing `dot_profile`, `lazy_loader`, `log_picker`, `bash_prompt_catppuccin_mocha`~~ → added.
- ~~Component table still lists `bash_prompt`~~ → removed with DOC-016.
- ~~Flag table is missing `DOTFILES_ENABLE_LAZY_LOADING`, `DOTFILES_ENABLE_LOG_PICKER`, `DOTFILES_ENABLE_NETWORK_WIDGET`, `DOTFILES_MOTD_STYLE`~~ → added (README got `DOTFILES_ENABLE_LAZY_LOADING` too).
- ~~MOTD section describes `motd/motd.sh` as a hostname router~~ → describes the real entry point after BUG-008.
- ~~Loading order block omits the lazy-loading branch~~ → added.

---

## 🟢 Low Priority

### 🐛 Bugs & Papercuts

| ID      | Title                                                                                           | Type   | Status  | Ref                                                                                                                        |
|---------|---------------------------------------------------------------------------------------------------|--------|---------|-------------------------------------------------------------------------------------------------------------------------------|
| BUG-013 | `motd/motd.sh:85` assigns `HOSTNAME=$(hostname)`, clobbering the shell's own `HOSTNAME`         | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | `motd.sh` is sourced (not executed) from `bashrc`/`zshrc`. Rename to `MOTD_HOSTNAME`                                        |
| BUG-014 | `motd/motd.sh:169` reads `${MOTD_SHOW_APT_UPDATES}` with no `:-` default                        | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | unset when `motd.sh` runs standalone; blocks DOC-003 (`set -u`). Every other read in the file already uses `:-`             |
| BUG-016 | `components/lazy_loader:42` uses loop variable `f` before the `local f` on line 55              | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | the first `for f in "${extra_funcs[@]}"` clobbers a global `$f`. Move the declaration above the loop                        |
| BUG-017 | `tput sgr0` called without error suppression                                                    | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | `config/dotfiles.config:19`, `motd/motd.sh:143` — stderr noise on unset/dumb `TERM`. `motd.sh:17` already does it correctly |
| BUG-019 | `motd/motd.sh:113` `cat /etc.defaults/VERSION` on the `odin` branch without an existence check   | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | any host named `odin` that is not a Synology NAS prints a `cat` error into the MOTD                                        |
| BUG-020 | `shopt` guard in `components/lazy_loader:34,64` is a silent no-op under zsh                     | 🐛 Bug | ✅ done [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603) | `shopt` does not exist in zsh; the `unalias` on line 41 is what actually protects zsh. Gate the block on `${BASH_VERSION}`  |

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
| NEW-019 | Add `DOTFILES_WSL_VERSION` (1 or 2) to platform detection, alongside existing boolean `DOTFILES_WSL` | 🆕 New-Feature | ✅ done [`ef11c59`](https://github.com/darkiop/dotfiles/commit/ef11c59) |
| DOC-014 | macOS bash upgrade guide in README.md (bash 4+ for FZF tab completion)                               | 📄 Chore       | ✅ done [`f645274`](https://github.com/darkiop/dotfiles/commit/f645274) |

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
| BUG-011 | Declare `DOTFILES_ENABLE_NETWORK_WIDGET` as a real feature flag                 | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | default `false`; `widgets.sh` bootstraps `feature_flags` now |
| BUG-012 | Stop retrying the auto-update pull on every shell start                        | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | counter resets on failure too, pull capped at 30s          |
| BUG-013 | Rename the MOTD `HOSTNAME` variable                                            | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | `MOTD_HOSTNAME` / `MOTD_HOSTNAME_SHORT`                    |
| BUG-014 | Default `MOTD_SHOW_APT_UPDATES` when reading it                                | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | unblocks DOC-003 (`set -u`)                                |
| BUG-015 | Make the MOTD tree renderer work on bash 3.2                                   | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | associative array replaced by a per-category scan          |
| BUG-016 | Declare `local f` before the first loop in `lazy_loader`                       | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               |                                                            |
| BUG-017 | Suppress `tput sgr0` errors on a dumb or unset `TERM`                          | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | `config/dotfiles.config`, `motd/motd.sh`                   |
| BUG-018 | Prepend the personal bin dirs to `PATH`                                        | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | new `ADD_TO_PATH_FRONT` in `bashrc` + `zshrc`              |
| BUG-019 | Check `/etc.defaults/VERSION` before reading it on the `odin` branch           | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | falls back to `uname -s`                                   |
| BUG-020 | Gate the `shopt` block in `lazy_loader` on `${BASH_VERSION}`                    | 🐛 Bug      | [`ecb5603`](https://github.com/darkiop/dotfiles/commit/ecb5603)                                                               | it was a silent no-op under zsh                            |
| BUG-008 | Turn the unrouted per-host MOTD files into widgets                             | 🐛 Bug      | [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40)                                                               | `motd-odin.sh` → `widgets/odin/storage-volume1.sh`; `motd-proxmox.sh` → built-in `proxmox-version` + `proxmox-services` |
| BUG-009 | One MOTD entry point for login and the `motd` alias                            | 🐛 Bug      | [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40)                                                               | both run `motd-catppuccin-mocha.sh` in a child shell, so nothing leaks into the shell |
| DOC-016 | Delete the dead prompt components                                              | 📄 Chore    | [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40)                                                               | `bash_prompt`, `bash_prompt_catppuccin_mocha_2`; `dot_profile` now profiles the prompt that is actually sourced |
| DOC-017 | Resync AGENTS.md / CLAUDE.md / copilot-instructions.md with the code           | 📄 Chore    | [`4a56c40`](https://github.com/darkiop/dotfiles/commit/4a56c40)                                                               | component count, component + flag tables, loading order, MOTD section |
| DOC-003 | Run the MOTD scripts under `set -euo pipefail`                                 | 📄 Chore    | [`d8ec7c9`](https://github.com/darkiop/dotfiles/commit/d8ec7c9)                                                               | see the DOC-003 notes above                                |
| BUG-021 | Drop the `declare -A` command cache in the MOTD widgets                        | 🐛 Bug      | [`406b355`](https://github.com/darkiop/dotfiles/commit/406b355)                                                                                                                     | `:`-delimited string + `case`; every widget is gated again on bash 3.2 |
| NEW-019 | Detect the WSL version, not just "is WSL"                                      | 🆕 New-Feature | [`ef11c59`](https://github.com/darkiop/dotfiles/commit/ef11c59)                                                                                                                  | `DOTFILES_WSL_VERSION` + `dotfiles_is_wsl1`/`dotfiles_is_wsl2`; `dot doctor` prints `[WSL2]` |
| DOC-014 | macOS bash upgrade guide in README.md                                          | 📄 Chore    | [`f645274`](https://github.com/darkiop/dotfiles/commit/f645274)                                                                                                                     | what breaks on bash 3.2, `brew install bash`, `/etc/shells` + `chsh` |

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
| 30 min | BUG-022: fix the `COLOR_SUCCESS` escape mismatch | 🐛 Bug      | `motd/motd-catppuccin-mocha.sh:20`          |

Cleared: ~~BUG-021~~, ~~NEW-019~~, ~~DOC-014~~ (all done).
