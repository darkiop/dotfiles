# Ideas

## Navi als submodule

Passe die:

AGENTS.md
CLAUDE.md
copilot-instructions.md

an:

Texte (Kommentare, Hilfetexte in READMEs, etc.) immer in english und in natürlicher Sprache (kein KI Speak) formulieren. Versuche auch möglichst viel Information auf wenig Text zubekommen.

## Shells

Unter Window > Powershell
- oh-my-posh

## docker

einbinden von, optional
https://github.com/Mikescher/better-docker-ps?tab=readme-ov-file
oder
https://github.com/devemio/docker-color-output

## motd

docker widget: auch anzeigen wenn keine container laufenc

widgetize the current standard lines

## Proposal Table

| ID | Priority | Name | Category | Complexity | Dependencies | Estimated Effort |
|----|----------|------|----------|------------|--------------|------------------|
| P001 | 1 | Kubernetes/kubectl fzf helpers | Integration | Medium | kubectl, fzf | 3-5h |
| P002 | 1 | Systemd unit manager with fzf | System | Low | systemctl, fzf | 2-3h |
| P003 | 1 | Project/Directory bookmarks | Navigation | Low | fzf | 2-3h |
| P004 | 1 | Environment switcher | Configuration | Medium | - | 3-4h |
| P005 | 2 | Extended Git helpers | VCS | Low-Medium | git, fzf | 4-6h |
| P006 | 2 | Performance profiling for shell startup | Debugging | Low | - | 2-3h |
| P007 | 2 | Config validator | QA | Medium | shellcheck | 3-4h |
| P008 | 3 | Snippet manager | Productivity | Medium | fzf | 4-6h |
| P009 | 3 | Remote host manager | Networking | Medium | ssh, fzf | 5-7h |
| P010 | 3 | Plugin system | Architecture | High | - | 8-12h |
| P011 | 3 | Backup & Sync | Maintenance | Medium | rsync, git | 5-7h |
| P012 | 3 | Process manager helpers | System | Low | fzf, ps | 2-3h |
| P013 | 4 | Secret scanner | Security | Medium | gitleaks/trufflehog | 3-4h |
| P014 | 4 | Audit log | Security | Medium | - | 4-5h |
| P015 | 5 | Cloud CLI helpers (AWS/GCP/Azure) | Integration | High | aws/gcp/az cli, fzf | 8-12h |
| P016 | 5 | Database connection manager | Integration | Medium | psql/mysql/redis-cli | 4-6h |
| P017 | 5 | AI helper integration | AI | Medium | curl, api keys | 3-5h |
| P018 | 2 | Interactive installer enhancements | UX | Medium | - | 4-6h |
| P019 | 3 | Theme switcher | UX | Low-Medium | - | 3-4h |
| P020 | 3 | Command history insights | Analytics | Medium | awk, sort | 3-4h |
| P021 | 2 | MOTD extensions | UI | Low-Medium | docker/kubectl | 3-5h |
| P022 | 2 | FZF preview enhancements | UX | Low | bat | 2-3h |
| P023 | 3 | Multi-shell support (Fish/PowerShell) | Compatibility | High | fish/pwsh | 10-15h |
| P024 | 3 | Network tools helpers | Networking | Low | ss/netstat, fzf | 2-3h |
| P025 | 3 | File finder with context | Navigation | Low-Medium | find, fzf, bat | 2-3h |
| P026 | 4 | Clipboard manager integration | Productivity | Low | clipmenu/xclip | 2-3h |
| P027 | 4 | Password manager CLI integration | Security | Medium | pass/op/bw | 3-4h |
| P028 | 5 | Weather widget | Fun | Low | curl | 1-2h |
| P029 | 5 | Calendar integration | Productivity | Medium | gcalcli/khal | 3-4h |
| P030 | 3 | Note-taking system | Productivity | Low-Medium | fzf, editor | 2-4h |

## Priority Legend

- **Priority 1**: Quick wins - High value, easy implementation
- **Priority 2**: Core improvements - Enhances existing features
- **Priority 3**: Extended features - Adds significant new functionality
- **Priority 4**: Security & Compliance - Important but specialized
- **Priority 5**: Integration & Ecosystem - Platform-specific or external deps

## Complexity Legend

- **Low**: 1-3 hours, straightforward implementation
- **Low-Medium**: 2-4 hours, some design decisions needed
- **Medium**: 3-7 hours, requires careful planning
- **High**: 8+ hours, significant architecture work

## Quick Reference by Category

### Integration (External Tools)
- P001 (Kubernetes), P015 (Cloud CLIs), P016 (Databases), P017 (AI)

### Navigation & Productivity
- P003 (Bookmarks), P008 (Snippets), P025 (File finder), P030 (Notes)

### System Management
- P002 (Systemd), P012 (Process manager), P024 (Network tools)

### Git & VCS
- P005 (Extended Git helpers)

### Security
- P013 (Secret scanner), P014 (Audit log), P027 (Password manager)

### UX & Interface
- P018 (Installer), P019 (Themes), P021 (MOTD), P022 (FZF previews)

### Configuration & Environment
- P004 (Env switcher), P007 (Validator), P010 (Plugin system), P011 (Backup)

### Debugging & Analytics
- P006 (Performance profiling), P020 (History insights)

---

## Detailed Proposals

### P001: Kubernetes/kubectl fzf helpers

**Description**: Interactive fzf-based helpers for Kubernetes management, similar to existing fzf_docker component.

**Features**:
- `kpods` - Interactive pod selector with namespace filtering
- `klogs` - View logs from selected pod/container
- `kexec` - Execute shell in selected pod
- `kdesc` - Describe selected resource (pods/services/deployments)
- `kctx` - Switch between kubectl contexts
- `kns` - Switch namespace

**Feature Flag**: `DOTFILES_ENABLE_KUBECTL_FZF`

**Files to create**:
- `components/fzf_kubectl`
- Add entry to `config/dot_help.json`

---

### P002: Systemd unit manager with fzf

**Description**: Enhanced systemd service management building on existing journalctl_picker.

**Features**:
- `sctl` - Interactive service selector with actions
- Actions: start, stop, restart, reload, enable, disable, status
- Preview shows current status and recent logs
- Sudo handling for privileged operations

**Feature Flag**: `DOTFILES_ENABLE_SYSTEMCTL_FZF`

**Files to create**:
- `components/fzf_systemctl`
- Add entry to `config/dot_help.json`

---

### P003: Project/Directory bookmarks

**Description**: Bookmark frequently used directories for instant navigation.

**Features**:
- `mark [name]` - Bookmark current directory
- `jump` or `j` - fzf picker for bookmarks with preview
- `unmark` - Remove bookmark
- `marks` - List all bookmarks
- Persistent storage in `~/.dotfiles_bookmarks` (JSON format)

**Feature Flag**: `DOTFILES_ENABLE_BOOKMARKS`

**Files to create**:
- `components/bookmarks`
- Add entries to `config/dot_help.json`

---

### P004: Environment switcher

**Description**: Manage multiple environment configurations (dev/staging/prod).

**Features**:
- `dotenv list` - Show available environments
- `dotenv switch <name>` - Switch to environment
- `dotenv current` - Show active environment
- Loads environment-specific configs from `config/environments/`
- Integration with cloud provider profiles (AWS, GCP, kubectl contexts)

**Feature Flag**: `DOTFILES_ENABLE_ENV_SWITCHER`

**Files to create**:
- `components/env_switcher`
- `config/environments/` (directory)
- Add entries to `config/dot_help.json`

---

### P005: Extended Git helpers

**Description**: Additional git workflows building on existing fzf_git component.

**Features**:
- `gwip` - Create WIP commit with timestamp
- `gundo` - Interactive undo of last N commits
- `gclean` - Cleanup merged/stale branches interactively
- `gworktree` - Worktree management via fzf
- `gbrowse` - Compare branches with diff preview
- `gblame-fzf` - Interactive git blame with commit details

**Feature Flag**: `DOTFILES_ENABLE_GIT_FZF` (reuse existing)

**Files to modify**:
- `components/fzf_git` (extend)
- Update `config/dot_help.json`

---

### P006: Performance profiling for shell startup

**Description**: Diagnose slow shell startup times by measuring component load times.

**Features**:
- `dot profile` - Run full startup profiling
- Reports load time for each component
- Identifies top 10 slowest components
- Suggests optimization strategies
- Output in both human-readable and JSON format

**Feature Flag**: Always available via dot command

**Files to create**:
- `components/profiler`
- Add logic to measure sourcing times in bashrc/zshrc

---

### P007: Config validator

**Description**: Validate dotfiles configuration and scripts, extending dot doctor.

**Features**:
- `dot validate` - Run full validation suite
- Syntax checking with shellcheck
- Detects common mistakes (unquoted variables, etc.)
- Warns about deprecated features
- Checks for broken symlinks and references

**Feature Flag**: `DOTFILES_ENABLE_DOT_DOCTOR` (reuse existing)

**Files to modify**:
- `components/dot_doctor` (extend)
- Update `config/dot_help.json`

---

### P008: Snippet manager

**Description**: Store and retrieve command snippets with parameter substitution, beyond dcheat functionality.

**Features**:
- `snip add <name>` - Save current command or interactive input
- `snip run <name>` - Execute snippet with parameter prompts
- `snip list` - fzf picker for snippets
- `snip edit <name>` - Edit snippet in $EDITOR
- `snip delete <name>` - Remove snippet
- Template variables: `{{var}}` with interactive substitution
- Storage in `~/.dotfiles_snippets/` (JSON format)

**Feature Flag**: `DOTFILES_ENABLE_SNIPPETS`

**Files to create**:
- `components/snippets`
- Add entries to `config/dot_help.json`

---

### P009: Remote host manager

**Description**: Enhanced remote host management building on ssh_picker.

**Features**:
- `hosts add` - Add new host with metadata
- `hosts list` - View all hosts grouped by tags
- `hosts edit` - Edit host configuration
- `hosts connect` - Connect via fzf picker
- `hosts tunnel` - Manage SSH tunnels/port forwards
- Host metadata: tags, notes, jump host, custom configs
- Storage in `~/dotfiles/config/hosts.json`

**Feature Flag**: `DOTFILES_ENABLE_HOST_MANAGER`

**Files to create**:
- `components/host_manager`
- Add entries to `config/dot_help.json`

---

### P010: Plugin system

**Description**: Modular plugin architecture for user extensions.

**Features**:
- `~/dotfiles/plugins/` directory for user plugins
- Auto-discovery and loading of plugins
- `dot plugin new <name>` - Create plugin from template
- `dot plugin list` - Show installed plugins
- `dot plugin enable/disable <name>` - Toggle plugins
- Plugin manifest (JSON) with metadata and dependencies
- Hooks: pre-prompt, post-command, custom keybindings

**Feature Flag**: `DOTFILES_ENABLE_PLUGINS`

**Files to create**:
- `components/plugin_system`
- `plugins/.template/` (plugin template)
- Add entries to `config/dot_help.json`

---

### P011: Backup & Sync

**Description**: Backup and synchronize dotfiles configurations across hosts.

**Features**:
- `dot backup` - Create timestamped backup
- `dot backup list` - Show available backups
- `dot backup restore <timestamp>` - Restore from backup
- `dot sync push` - Push local configs to remote
- `dot sync pull` - Pull configs from remote
- Support for encrypted secrets (gpg)
- Configurable backup targets (local/remote)

**Feature Flag**: `DOTFILES_ENABLE_BACKUP`

**Files to create**:
- `components/backup_sync`
- Add entries to `config/dot_help.json`

---

### P012: Process manager helpers

**Description**: Interactive process management with fzf.

**Features**:
- `psfzf` - Process picker with actions (kill, nice, renice, info)
- Preview shows process details (cpu, mem, tree, open files)
- `pstree-fzf` - Navigate process tree interactively
- Integration with htop/btop if available
- Safety confirmation for kill operations

**Feature Flag**: `DOTFILES_ENABLE_PROCESS_FZF`

**Files to create**:
- `components/fzf_process`
- Add entries to `config/dot_help.json`

---

### P013: Secret scanner

**Description**: Scan dotfiles for accidentally committed secrets.

**Features**:
- `dot secrets-scan` - Scan all dotfiles for secrets
- Integration with gitleaks or trufflehog
- Custom patterns for common secrets (API keys, passwords, tokens)
- Pre-commit hook (optional)
- Whitelist for false positives

**Feature Flag**: `DOTFILES_ENABLE_SECRET_SCANNER`

**Files to create**:
- `components/secret_scanner`
- `.gitleaks.toml` or similar config
- Add entry to `config/dot_help.json`

---

### P014: Audit log

**Description**: Track important dotfiles operations for troubleshooting.

**Features**:
- `dot audit` - View audit log
- Automatic logging of: installs, updates, config changes
- Log format: timestamp, operation, user, outcome
- Storage in `~/.dotfiles_audit.log`
- Rotation policy for large logs

**Feature Flag**: `DOTFILES_ENABLE_AUDIT_LOG`

**Files to create**:
- `components/audit_log`
- Modify install.sh and components/dot_help to log operations
- Add entry to `config/dot_help.json`

---

### P015: Cloud CLI helpers (AWS/GCP/Azure)

**Description**: fzf-based helpers for major cloud providers.

**Features**:

**AWS**:
- `awsp` - Switch AWS profile interactively
- `ec2fzf` - Browse EC2 instances with actions (connect, start, stop)
- `s3fzf` - Navigate S3 buckets and objects
- `lambdafzf` - View and invoke Lambda functions

**GCP**:
- `gcpfzf` - Switch GCP project
- `gcefzf` - Browse GCE instances

**Azure**:
- `azfzf` - Switch Azure subscription
- `vmfzf` - Browse Azure VMs

**Feature Flag**: `DOTFILES_ENABLE_CLOUD_FZF` (with sub-flags per provider)

**Files to create**:
- `components/fzf_cloud`
- Add entries to `config/dot_help.json`

---

### P016: Database connection manager

**Description**: Manage database connections with encrypted credentials.

**Features**:
- `dbconnect` - Interactive DB connection picker
- Support for: PostgreSQL, MySQL, Redis, MongoDB, SQLite
- Connection storage in `~/dotfiles/config/databases.json` (encrypted)
- Preview shows connection details (without password)
- `dbadd` - Add new connection
- `dbedit` - Edit connection
- GPG encryption for sensitive data

**Feature Flag**: `DOTFILES_ENABLE_DB_MANAGER`

**Files to create**:
- `components/db_manager`
- Add entries to `config/dot_help.json`

---

### P017: AI helper integration

**Description**: Integrate AI assistance into CLI workflows.

**Features**:
- `ai <question>` - Ask AI from terminal
- `ai explain <command>` - Explain command
- `ai suggest` - Suggest command for natural language query
- `ai fix` - Suggest fix for failed command
- Support for multiple backends (OpenAI, Anthropic, local LLMs)
- API key management in config
- Conversation history (optional)

**Feature Flag**: `DOTFILES_ENABLE_AI_HELPER`

**Files to create**:
- `components/ai_helper`
- Add entries to `config/dot_help.json`

---

### P018: Interactive installer enhancements

**Description**: Improve install.sh user experience.

**Features**:
- Preview mode: show what will be changed before applying
- Dependency graph visualization
- Progress bar for long operations
- Rollback on error
- Dry-run mode (`install.sh --dry-run`)
- Installation logging
- Component descriptions in menu

**Feature Flag**: N/A (always active in installer)

**Files to modify**:
- `install.sh`

---

### P019: Theme switcher

**Description**: Switch between different visual themes for prompt and colors.

**Features**:
- `dot theme list` - Show available themes
- `dot theme set <name>` - Apply theme
- `dot theme current` - Show active theme
- Built-in themes: minimal, verbose, colorful, monochrome, solarized
- Custom themes in `~/dotfiles/config/themes/`
- Per-host theme configuration

**Feature Flag**: `DOTFILES_ENABLE_THEMES`

**Files to create**:
- `components/theme_switcher`
- `config/themes/` (directory with theme files)
- Add entries to `config/dot_help.json`

---

### P020: Command history insights

**Description**: Analyze shell usage patterns and suggest optimizations.

**Features**:
- `dot stats` - Show command usage statistics
- Top 20 most used commands
- Suggest aliases for frequently typed commands
- Detect unused dotfiles features
- Show command frequency trends
- Export stats to JSON

**Feature Flag**: `DOTFILES_ENABLE_HISTORY_INSIGHTS`

**Files to create**:
- `components/history_insights`
- Add entry to `config/dot_help.json`

---

### P021: MOTD extensions

**Description**: Enhance existing MOTD with additional widgets.

**Features**:
- Docker container status (running/stopped counts)
- Kubernetes cluster info (if kubectl configured)
- Custom widgets per host via `motd/widgets/<hostname>/`
- Integration with monitoring systems (Prometheus metrics)
- Weather info (optional)
- System health score
- News/RSS feeds (optional)

**Feature Flag**: `DOTFILES_ENABLE_MOTD` (extend existing)

**Files to modify**:
- `motd/motd.sh`
- Add widget system in `motd/widgets/`

---

### P022: FZF preview enhancements

**Description**: Improve fzf preview across all components.

**Features**:
- Syntax highlighting in all previews (bat integration)
- Dynamic preview window sizing (toggle with key)
- Custom preview commands per context
- Image preview support (if terminal supports)
- Preview caching for performance
- Line number highlighting in file previews

**Feature Flag**: `DOTFILES_ENABLE_FZF` (existing flag)

**Files to modify**:
- All components using fzf
- Create shared preview helper in `components/fzf_preview_helpers`

---

### P023: Multi-shell support (Fish/PowerShell)

**Description**: Extend support beyond Bash/Zsh.

**Features**:
- Fish shell configuration (fishrc equivalent)
- PowerShell Core support (profile.ps1)
- Shared component logic across all shells
- Shell-specific adaptations where needed
- Migration guides

**Feature Flag**: `DOTFILES_ENABLE_FISH`, `DOTFILES_ENABLE_PWSH`

**Files to create**:
- `fishrc`, `config/fish/`
- `profile.ps1`, `config/powershell/`
- Shell-specific components

---

### P024: Network tools helpers

**Description**: Interactive network diagnostics and management.

**Features**:
- `netfzf` - Browse listening ports with process info
- Actions: kill process, show connections, copy port number
- `curlfzf` - Saved HTTP requests with history
- Request templates with variable substitution
- `sshfzf` - Active SSH connections manager
- `ncfzf` - netcat helper with common use cases

**Feature Flag**: `DOTFILES_ENABLE_NETWORK_FZF`

**Files to create**:
- `components/fzf_network`
- Add entries to `config/dot_help.json`

---

### P025: File finder with context

**Description**: Enhanced file finding with actions and preview.

**Features**:
- `ff [pattern]` - Find files interactively
- Preview with syntax highlighting (bat)
- Actions: open, edit, copy path, move, delete, show in dir
- Filter by type, size, date modified
- Search in file contents (ripgrep integration)
- Respects .gitignore

**Feature Flag**: `DOTFILES_ENABLE_FILE_FINDER`

**Files to create**:
- `components/file_finder`
- Add entry to `config/dot_help.json`

---

### P026: Clipboard manager integration

**Description**: Integrate with system clipboard manager.

**Features**:
- `clip` - fzf picker for clipboard history
- Auto-copy for certain operations (git hashes, paths)
- `clipadd` - Add to clipboard
- `clipsave` - Save clipboard snippets permanently
- Integration with clipmenu, copyq, or similar

**Feature Flag**: `DOTFILES_ENABLE_CLIPBOARD_MANAGER`

**Files to create**:
- `components/clipboard_manager`
- Add entries to `config/dot_help.json`

---

### P027: Password manager CLI integration

**Description**: Integrate password managers into CLI workflow.

**Features**:
- `pwfzf` - Interactive password picker
- Support for: pass (password-store), 1Password CLI, Bitwarden CLI
- Copy password to clipboard with auto-clear timeout
- Show password metadata without revealing secrets
- TOTP support
- Auto-type functionality (if supported)

**Feature Flag**: `DOTFILES_ENABLE_PASSWORD_MANAGER`

**Files to create**:
- `components/password_manager`
- Add entries to `config/dot_help.json`

---

### P028: Weather widget

**Description**: Display weather information in terminal.

**Features**:
- `weather` - Show current weather
- Integration with wttr.in or similar API
- Display in MOTD (optional)
- Location configuration (auto-detect or manual)
- Forecast mode (`weather forecast`)

**Feature Flag**: `DOTFILES_ENABLE_WEATHER`

**Files to create**:
- `components/weather`
- Add entry to `config/dot_help.json`

---

### P029: Calendar integration

**Description**: View upcoming calendar events in terminal.

**Features**:
- Display next N events in MOTD
- `cal` or `agenda` - Show calendar view
- Integration with gcalcli (Google Calendar) or khal (local)
- Event filtering by calendar
- Quick event creation

**Feature Flag**: `DOTFILES_ENABLE_CALENDAR`

**Files to create**:
- `components/calendar`
- Add entries to `config/dot_help.json`

---

### P030: Note-taking system

**Description**: Quick note-taking and retrieval system.

**Features**:
- `note` - Create new note or search existing
- `note <text>` - Quick note creation with timestamp
- `note search` - fzf picker for notes with preview
- `note edit` - Edit note in $EDITOR
- Markdown support
- Tagging system
- Storage in `~/dotfiles/notes/` or `~/.notes/`

**Feature Flag**: `DOTFILES_ENABLE_NOTES`

**Files to create**:
- `components/notes`
- Add entries to `config/dot_help.json`

---

## Implementation Priority Matrix

### Start Here (High Value, Low Effort)
- P003 (Bookmarks)
- P006 (Performance profiling)
- P012 (Process helpers)
- P024 (Network tools)
- P025 (File finder)

### High Impact Projects
- P001 (Kubernetes) - if working with K8s
- P005 (Extended Git) - builds on existing strength
- P008 (Snippets) - major productivity boost

### Long-term Investments
- P010 (Plugin system) - enables community contributions
- P023 (Multi-shell) - broader user base
- P015 (Cloud CLIs) - comprehensive but valuable

---

## Contributing

To propose a new enhancement:
1. Add a new row to the table with next available ID (P031+)
2. Create detailed proposal section
3. Submit PR with rationale and use cases

## Status Tracking

Track implementation status in [GitHub Projects](https://github.com/darkiop/dotfiles/projects) or add a status column to this table.
