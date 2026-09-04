# TODO

Zusammengeführt aus `IDEAS.md` und `IMPROVEMENTS.md`. Letzte Aktualisierung: 2026-09-04 (Backlog-Audit gegen Code-Stand).

**Status-Werte:** `offen` | `in Arbeit` | `erledigt` | `verworfen`
**Prioritäten:** `kritisch` | `hoch` | `mittel` | `niedrig`

---

## Übersicht

| ID | Titel | Kategorie | Priorität | Aufwand | Status | Beschreibung |
|----|-------|-----------|-----------|---------|--------|--------------|
| [IMP-001](#imp-001) | ioBroker Source-Validierung | Sicherheit | kritisch | 30 min | offen | Existenzprüfung vor dem Sourcen von ioBroker-Dateien hinzufügen |
| [IMP-002](#imp-002) | Hardcodierten Username entfernen | Sicherheit | kritisch | 30 min | offen | `$USER == "darkiop"` Check in ioBroker-Integration entfernen oder via Feature-Flag konfigurierbar machen |
| [IMP-003](#imp-003) | WOL MAC-Adressen auslagern | Sicherheit | kritisch | 1h | offen | MAC-Adressen aus alias-Datei in verschlüsselte Config oder Umgebungsvariablen verschieben |
| [IMP-004](#imp-004) | Secret-Scanning + Scanner | Sicherheit | kritisch | 3–4h | offen | Pre-Commit Hooks + `dot secrets-scan` für API-Keys, Tokens, Credentials (gitleaks/trufflehog). Vereint mit ehem. P013 |
| [IMP-005](#imp-005) | IPv6-Erkennung SSH tmux rename | Bug | kritisch | 1h | offen | Regex für IP-Erkennung um IPv6 erweitern (`bashrc:170`, `zshrc:161`) |
| [IMP-006](#imp-006) | Docker Widget Daemon/Leer-Status | Bug | hoch | 1h | offen | Widget auch bei 0 Containern anzeigen (solange Daemon läuft) und "Daemon down" davon unterscheiden (`motd/widgets.sh:97-99`). Vereint mit ehem. IDX-005 |
| [IMP-007](#imp-007) | Startup-Profiler | Performance | mittel | 2–3h | offen | `dot profile` Command zur Messung der Shell-Startzeit pro Komponente implementieren |
| [IMP-008](#imp-008) | Lazy-Loading Komponenten | Performance | mittel | 3–5h | offen | Selten genutzte Komponenten erst bei Aufruf laden statt beim Shell-Start |
| [IMP-009](#imp-009) | Feature-Flag-Caching | Performance | mittel | 2–3h | offen | Flags einmal vorab berechnen statt 40+ mal beim Start aufrufen |
| [IMP-010](#imp-010) | Directory Bookmarks | Feature | mittel | 2–3h | offen | `mark`, `jump`, `unmark`, `marks` Commands mit persistenter Speicherung in `~/.dotfiles_bookmarks` |
| [IMP-011](#imp-011) | Process Manager | Feature | mittel | 2–3h | offen | `psfzf` für interaktive Prozessauswahl mit Actions (kill, nice, renice, info) |
| [IMP-012](#imp-012) | Installer Dry-Run | Feature | mittel | 4–6h | offen | `install.sh --dry-run` Modus: Vorschau aller Änderungen vor Ausführung |
| [IMP-013](#imp-013) | Architektur-Diagramm | Dokumentation | mittel | 1h | offen | Visuelles Diagramm der Ladereihenfolge in README.md ergänzen |
| [IMP-014](#imp-014) | Troubleshooting-Guide | Dokumentation | mittel | 2–3h | offen | Guide für häufige Probleme: langsamer Shell-Start, macOS bash 3.2, WSL, Container |
| [IMP-015](#imp-015) | Kompatibilitätsmatrix | Dokumentation | mittel | 1–2h | offen | Dokumentieren welche Features bash 4+/zsh 5.0+ benötigen und was auf macOS vs. Linux läuft |
| [IMP-016](#imp-016) | Error Handling in MOTD-Scripts | Code-Qualität | niedrig | 1–2h | offen | `set -euo pipefail` in `motd/motd.sh`, `motd/widgets.sh` + Widget-Scripts (`install.sh` hat bereits `set -e`) |
| [IMP-017](#imp-017) | PATH-Management vereinfachen | Code-Qualität | mittel | 1h | offen | Array-basiertes PATH-Management statt wiederholter `ADD_TO_PATH` Aufrufe |
| [IMP-018](#imp-018) | FZF-Komponente aufteilen | Code-Qualität | mittel | 2–3h | offen | `components/fzf` (166 Zeilen) in `fzf_core` und `fzf_tab_completion` aufteilen |
| [IMP-019](#imp-019) | Shellcheck Suppressions reduzieren | Code-Qualität | mittel | 3–5h | offen | 36 Suppressions (SC2312, SC2086, SC1090) in 13 Dateien auditieren und reduzieren |
| [IMP-020](#imp-020) | Alias-Datei aufteilen | Organisation | niedrig | 2–3h | offen | `alias/alias` (372 Zeilen) in `alias-core`, `alias-system`, `alias-dev` aufteilen |
| [IMP-021](#imp-021) | Plugin-System | Architektur | niedrig | 8–12h | offen | `plugins/` Verzeichnis mit Auto-Discovery für User-Erweiterungen ohne Core-Änderungen |
| [IMP-022](#imp-022) | Cheats reorganisieren | Organisation | niedrig | 2h | offen | 57 Cheat-Dateien in Kategorie-Unterverzeichnisse (`docker/`, `git/`, `kubernetes/`) sortieren |
| [IMP-023](#imp-023) | CI/CD Pipeline | Testing | niedrig | 3–5h | offen | GitHub Actions mit Shellcheck-Validierung für automatisierte Qualitätssicherung |
| [IMP-024](#imp-024) | BATS Test-Suite | Testing | niedrig | 8–12h | offen | Integration Tests mit Bash Automated Testing System für Komponenten, Flags, FZF, MOTD |
| [IMP-026](#imp-026) | WSL-Version erkennen | Kompatibilität | niedrig | 1h | offen | `DOTFILES_WSL_VERSION` (1 oder 2) zusätzlich zum bestehenden boolean `DOTFILES_WSL` hinzufügen |
| [IMP-027](#imp-027) | macOS bash-Upgrade Guide | Dokumentation | niedrig | 1h | offen | Upgrade-Anleitung für bash 4+ auf macOS in README.md (FZF Tab-Completion benötigt bash 4+) |
| [IDX-001](#idx-001) | Navi als Submodule | Integration | mittel | 3–5h | offen | https://github.com/denisidoro/navi als git Submodule integrieren |
| [IDX-002](#idx-002) | Agent-Instruktionen überarbeiten | Dokumentation | mittel | 1–2h | offen | AGENTS.md, CLAUDE.md, copilot-instructions.md: Texte auf Englisch, natürliche Sprache, kein KI-Speak |
| [IDX-003](#idx-003) | Windows PowerShell (oh-my-posh) | Kompatibilität | niedrig | 10–15h | offen | PowerShell-Unterstützung mit oh-my-posh für Windows-Umgebungen |
| [IDX-004](#idx-004) | Docker Output Colorizer | Integration | niedrig | 1–2h | offen | Optional: better-docker-ps oder docker-color-output einbinden |
| [IDX-006](#idx-006) | MOTD Standardzeilen als Widgets | Feature | mittel | 3–5h | offen | Aktuelle hartcodierte MOTD-Ausgaben in das Widget-System überführen |
| [P001](#p001) | kubectl fzf Helpers | Integration | mittel | 3–5h | offen | `kpods`, `klogs`, `kexec`, `kdesc`, `kctx`, `kns` — analog zu fzf_docker |
| [P004](#p004) | Environment Switcher | Feature | mittel | 3–4h | offen | `dotenv switch <name>` für dev/staging/prod Konfigurationen aus `config/environments/` |
| [P005](#p005) | Extended Git Helpers | Feature | hoch | 4–6h | offen | `gwip`, `gundo`, `gclean`, `gworktree`, `gbrowse`, `gblame-fzf` in fzf_git ergänzen |
| [P007](#p007) | Config Validator + dot doctor | QA | mittel | 3–4h | offen | `dot validate`: Shellcheck, Syntax-Check, Flag-Typo-Erkennung, Deprecated-Features (Symlink-Check bereits in `dot_doctor`). Vereint mit ehem. IMP-025 |
| [P008](#p008) | Snippet Manager | Produktivität | mittel | 4–6h | offen | `snip add/run/list/edit/delete` mit Template-Variablen (`{{var}}`) und fzf-Picker |
| [P009](#p009) | Remote Host Manager | Netzwerk | mittel | 5–7h | offen | `hosts add/list/edit/connect/tunnel` mit Metadaten, Tags und Storage in `config/hosts.json` |
| [P014](#p014) | Audit Log | Sicherheit | mittel | 4–5h | offen | `dot audit` — automatisches Logging von Installs, Updates und Config-Änderungen |
| [P015](#p015) | Cloud CLI Helpers | Integration | niedrig | 8–12h | offen | fzf-Helpers für AWS (`awsp`, `ec2fzf`), GCP (`gcpfzf`) und Azure (`azfzf`) |
| [P016](#p016) | Database Connection Manager | Integration | niedrig | 4–6h | offen | `dbconnect` mit Picker für PostgreSQL/MySQL/Redis/MongoDB, GPG-verschlüsselte Credentials |
| [P017](#p017) | AI Helper Integration | Integration | niedrig | 3–5h | offen | `ai <question>`, `ai explain`, `ai suggest`, `ai fix` mit Support für OpenAI/Anthropic/local LLMs |
| [P019](#p019) | Theme Switcher | UX | niedrig | 3–4h | offen | `dot theme list/set/current` mit Built-in Themes und Custom Themes in `config/themes/` |
| [P020](#p020) | Command History Insights | Analytics | niedrig | 3–4h | offen | `dot stats` — Top-20-Commands, Alias-Vorschläge, ungenutzte Features erkennen |
| [P022](#p022) | FZF Preview Enhancements | UX | mittel | 2–3h | offen | Syntax-Highlighting (bat), dynamische Preview-Größe, Image-Preview, geteilte Preview-Helpers |
| [P024](#p024) | Network Tools Helpers | Netzwerk | niedrig | 2–3h | offen | `netfzf` (Ports), `curlfzf` (HTTP-Requests), `sshfzf` (aktive Verbindungen) |
| [P025](#p025) | File Finder mit Kontext | Navigation | niedrig | 2–4h | offen | `ff [pattern]` mit Actions, bat-Preview, ripgrep-Volltextsuche und .gitignore-Support |
| [P026](#p026) | Clipboard Manager | Produktivität | niedrig | 2–3h | offen | `clip` fzf-Picker für Clipboard-Historie, Auto-Copy für git-Hashes und Pfade |
| [P027](#p027) | Password Manager Integration | Sicherheit | mittel | 3–4h | offen | `pwfzf` für pass/1Password/Bitwarden mit Clipboard-Timeout und TOTP-Support |
| [P028](#p028) | Weather Widget | Fun | niedrig | 1–2h | offen | `weather` Command via wttr.in, optional im MOTD anzeigen |
| [P029](#p029) | Calendar Integration | Produktivität | niedrig | 3–4h | offen | Nächste Events im MOTD, `agenda` Command, Integration mit gcalcli oder khal |
| [P030](#p030) | Notiz-System | Produktivität | niedrig | 2–4h | offen | `note [text]` mit fzf-Picker, Markdown, Tagging und Storage in `~/.notes/` |

---

## Details

### IMP-001
**ioBroker Source-Validierung** · Sicherheit · kritisch

Dateien `bashrc:184-185`, `zshrc:173-174` sourcen ioBroker-Dateien ohne Existenzprüfung. Bei fehlendem File entsteht ein Shell-Fehler.

```bash
[[ -f ~/.iobroker/iobroker_completions ]] && source ~/.iobroker/iobroker_completions
[[ -f ~/.iobroker/npm_command_fix ]] && source ~/.iobroker/npm_command_fix
```

---

### IMP-002
**Hardcodierten Username entfernen** · Sicherheit · kritisch

`bashrc:183`, `zshrc:172` prüfen `$USER == "darkiop"`. Entfernen oder via Feature-Flag konfigurierbar machen, damit das Repo portabel bleibt.

---

### IMP-003
**WOL MAC-Adressen auslagern** · Sicherheit · kritisch

`alias/alias:310-314` enthält MAC-Adressen im Klartext. In verschlüsselte Config oder Umgebungsvariablen (z.B. `config/local_dotfiles_settings`) verschieben.

---

### IMP-004
**Secret-Scanning + Scanner** · Sicherheit · kritisch

Keine Pre-Commit Hooks für API-Keys, Tokens, Credentials. gitleaks oder trufflehog einrichten. Vereint mit ehem. P013:

- `dot secrets-scan` — scannt alle Dotfiles nach versehentlich commiteten Secrets
- Optionaler Pre-Commit-Hook, Custom-Patterns, Whitelist für False Positives
- Neue Datei: `components/secret_scanner`, Feature-Flag: `DOTFILES_ENABLE_SECRET_SCANNER`
- Vorhandene Klartext-Secrets siehe [IMP-003](#imp-003) (WOL MAC-Adressen)

---

### IMP-005
**IPv6-Erkennung SSH tmux rename** · Bug · kritisch

`bashrc:170`, `zshrc:161` — Regex `^[0-9]+(\.[0-9]+){3}$` erkennt nur IPv4. IPv6-Adressen werden fälschlich als Hostnames behandelt und gekürzt.

```bash
# Verbessert (IPv4 und IPv6):
if [[ $target =~ ^[0-9]+(\.[0-9]+){3}$ ]] || [[ $target =~ : ]]; then
  : # IP-Adresse, behalten
else
  target=${target%%.*}
fi
```

---

### IMP-006
**Docker Widget Daemon/Leer-Status** · Bug · hoch

`motd/widgets.sh:97-99` — Widget macht aktuell `return 1` sowohl wenn der Daemon nicht läuft als auch bei 0 Containern; beide Zustände sind ununterscheidbar und unsichtbar. Vereint mit ehem. IDX-005:

- Daemon-Status vorab prüfen (`docker info`) und "Daemon down" getrennt ausgeben
- Bei laufendem Daemon auch mit 0 Containern anzeigen statt zu verstecken

---

### IMP-007
**Startup-Profiler** · Performance · mittel

`dot profile` Command — misst Ladezeit jeder Komponente, zeigt Top-10 der langsamsten, gibt Optimierungshinweise. Output als human-readable und JSON.

- Neue Datei: `components/profiler`
- Zeitmessung in `bashrc`/`zshrc` integrieren

---

### IMP-008
**Lazy-Loading Komponenten** · Performance · mittel

Alle Komponenten laden beim Shell-Start auch wenn sie selten genutzt werden. Selten genutzte via Wrapper-Funktion erst bei Aufruf laden.

```bash
_load_xyz() {
  [[ -v _xyz_loaded ]] && return
  source ~/dotfiles/components/xyz
  _xyz_loaded=1
}
```

---

### IMP-009
**Feature-Flag-Caching** · Performance · mittel

`dotfiles_flag_enabled` wird 40+ mal beim Start aufgerufen. Flags einmal vorab berechnen und als Variablen cachen.

---

### IMP-010
**Directory Bookmarks** · Feature · mittel

`mark [name]`, `jump`/`j`, `unmark`, `marks` — Verzeichnis-Lesezeichen mit fzf-Picker und Preview. Persistente Speicherung in `~/.dotfiles_bookmarks` (JSON).

- Neue Datei: `components/bookmarks`
- Feature-Flag: `DOTFILES_ENABLE_BOOKMARKS`

Siehe auch [P003 in IDEAS.md].

---

### IMP-011
**Process Manager** · Feature · mittel

`psfzf` — interaktiver Prozess-Picker mit Actions (kill, nice, renice, info), Preview mit CPU/Mem/Tree/Open-Files, Sicherheits-Bestätigung für Kill.

- Neue Datei: `components/fzf_process`
- Feature-Flag: `DOTFILES_ENABLE_PROCESS_FZF`

---

### IMP-012
**Installer Dry-Run** · Feature · mittel

`install.sh --dry-run` — zeigt alle Änderungen vor Ausführung, Fortschrittsanzeige, Rollback bei Fehler, Installations-Logging.

---

### IMP-013
**Architektur-Diagramm** · Dokumentation · mittel

Ladereihenfolge (`bashrc/zshrc → config → platform → feature_flags → ...`) als visuelles Diagramm in README.md ergänzen.

---

### IMP-014
**Troubleshooting-Guide** · Dokumentation · mittel

Abdeckung: langsamer Shell-Start diagnostizieren, macOS bash 3.2 vs. 4+, WSL-spezifische Gotchas, Container-Umgebungs-Erkennung.

---

### IMP-015
**Kompatibilitätsmatrix** · Dokumentation · mittel

Tabellarisch dokumentieren: welche Features bash 4+ oder zsh 5.0+ benötigen, was auf macOS vs. Linux läuft, Container-spezifische Einschränkungen.

---

### IMP-016
**Error Handling in MOTD-Scripts** · Code-Qualität · niedrig

`install.sh` hat bereits `set -e`. Verbleibend: `set -euo pipefail` in `motd/motd.sh`, `motd/widgets.sh` und alle Widget-Scripts einfügen. Vorsicht bei Widgets, die bewusst mit non-zero exits arbeiten (z.B. Docker-Widget `return 1`).

---

### IMP-017
**PATH-Management vereinfachen** · Code-Qualität · mittel

`bashrc/zshrc:14-26` — einzelne `ADD_TO_PATH` Aufrufe durch Array-Iteration ersetzen für bessere Lesbarkeit und Wartbarkeit.

---

### IMP-018
**FZF-Komponente aufteilen** · Code-Qualität · mittel

`components/fzf` (166 Zeilen) in `fzf_core` (Basis-Setup) und `fzf_tab_completion` (feature-gated) aufteilen.

---

### IMP-019
**Shellcheck Suppressions reduzieren** · Code-Qualität · mittel

36 Suppressions (häufig: SC2312, SC2086, SC1090) in 13 Dateien — Audit durchführen und begründete von unnötigen trennen.

---

### IMP-020
**Alias-Datei aufteilen** · Organisation · niedrig

`alias/alias` (372 Zeilen) in logische Einheiten aufteilen: `alias-core` (essentiell), `alias-system` (systemctl/reboot), `alias-dev` (git/docker).

---

### IMP-021
**Plugin-System** · Architektur · niedrig

`plugins/` Verzeichnis mit Auto-Discovery für User-Erweiterungen ohne Core-Dateien ändern zu müssen.

---

### IMP-022
**Cheats reorganisieren** · Organisation · niedrig

57 Cheat-Dateien flach im `cheats/` Verzeichnis in Unterverzeichnisse sortieren: `cheats/docker/`, `cheats/git/`, `cheats/kubernetes/`.

---

### IMP-023
**CI/CD Pipeline** · Testing · niedrig

GitHub Actions Workflow mit Shellcheck-Validierung für automatisierte Syntax- und Qualitätsprüfung bei jedem Push/PR.

---

### IMP-024
**BATS Test-Suite** · Testing · niedrig

Bash Automated Testing System einführen. Tests für: Komponenten-Loading (bash/zsh), Feature-Flags, FZF-Komponenten, Git-Alias-Funktionen, MOTD-Rendering.

---

### IMP-026
**WSL-Version erkennen** · Kompatibilität · niedrig

`DOTFILES_WSL_VERSION` Variable (Wert `1` oder `2`) zusätzlich zum bestehenden boolean `DOTFILES_WSL` in `components/platform` ergänzen.

---

### IMP-027
**macOS bash-Upgrade Guide** · Dokumentation · niedrig

FZF Tab-Completion benötigt bash 4+, macOS liefert bash 3.2. Upgrade-Anleitung (Homebrew) in README.md ergänzen.

---

### IDX-001
**Navi als Submodule** · Integration · mittel

https://github.com/denisidoro/navi als git Submodule analog zu fzf/oh-my-zsh einbinden. Plan: `modules/navi/` mit `install` Script, Feature-Flag `DOTFILES_ENABLE_NAVI` bereits vorhanden.

---

### IDX-002
**Agent-Instruktionen überarbeiten** · Dokumentation · mittel

`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` — Texte auf Englisch, natürliche Sprache statt KI-Speak, möglichst viel Information auf wenig Text.

---

### IDX-003
**Windows PowerShell (oh-my-posh)** · Kompatibilität · niedrig

PowerShell-Unterstützung für Windows mit oh-my-posh als Prompt-Framework.

---

### IDX-004
**Docker Output Colorizer** · Integration · niedrig

Optional: [better-docker-ps](https://github.com/Mikescher/better-docker-ps) oder [docker-color-output](https://github.com/devemio/docker-color-output) als optionale Verbesserung für Docker-Alias einbinden.

---

### IDX-006
**MOTD Standardzeilen als Widgets** · Feature · mittel

Aktuelle hartcodierte MOTD-Ausgaben (Hostname, Uptime, Last Login etc.) in das Widget-System überführen für einheitliche Konfiguration und bessere Erweiterbarkeit.

---

### P001
**kubectl fzf Helpers** · Integration · mittel

`kpods`, `klogs`, `kexec`, `kdesc`, `kctx`, `kns` — interaktive Kubernetes-Verwaltung analog zu `fzf_docker`.

- Neue Datei: `components/fzf_kubectl`
- Feature-Flag: `DOTFILES_ENABLE_KUBECTL_FZF`

---

### P004
**Environment Switcher** · Feature · mittel

`dotenv list/switch/current` — zwischen dev/staging/prod Konfigurationen wechseln, lädt Configs aus `config/environments/`, optionale Cloud-Provider-Profil-Integration.

- Neue Datei: `components/env_switcher`
- Feature-Flag: `DOTFILES_ENABLE_ENV_SWITCHER`

---

### P005
**Extended Git Helpers** · Feature · hoch

`gwip` (WIP-Commit), `gundo` (interaktives Undo), `gclean` (stale Branches), `gworktree` (Worktree via fzf), `gbrowse` (Branch-Vergleich), `gblame-fzf`.

- Erweiterung: `components/fzf_git`
- Flag: `DOTFILES_ENABLE_GIT_FZF` (bestehend)

---

### P007
**Config Validator + dot doctor** · QA · mittel

`dot validate` — Shellcheck-Integration, Syntax-Validierung aller Shell-Dateien, Feature-Flag-Validierung (Typos, unbekannte Flags), Erkennung veralteter Features, Referenz-/Broken-Source-Check, Warnung bei unbekannten Flags. Vereint mit ehem. IMP-025 (Symlink-Integrität ist bereits in `dot_doctor:137` implementiert).

- Erweiterung: `components/dot_doctor`
- Flag: `DOTFILES_ENABLE_DOT_DOCTOR` (bestehend)

---

### P008
**Snippet Manager** · Produktivität · mittel

`snip add/run/list/edit/delete` mit Template-Variablen (`{{var}}`), interaktiver Substitution und fzf-Picker. Speicherung in `~/.dotfiles_snippets/`.

- Neue Datei: `components/snippets`
- Feature-Flag: `DOTFILES_ENABLE_SNIPPETS`

---

### P009
**Remote Host Manager** · Netzwerk · mittel

`hosts add/list/edit/connect/tunnel` — erweitert `ssh_picker` um Metadaten, Tags, Jump-Host-Konfiguration und SSH-Tunnel-Verwaltung. Storage in `config/hosts.json`.

- Neue Datei: `components/host_manager`
- Feature-Flag: `DOTFILES_ENABLE_HOST_MANAGER`

---

### P014
**Audit Log** · Sicherheit · mittel

`dot audit` — automatisches Logging von Installs, Updates, Config-Änderungen mit Timestamp, Operation, User, Outcome. Storage in `~/.dotfiles_audit.log` mit Rotation.

- Neue Datei: `components/audit_log`
- Feature-Flag: `DOTFILES_ENABLE_AUDIT_LOG`

---

### P015
**Cloud CLI Helpers** · Integration · niedrig

fzf-Helpers für AWS (`awsp`, `ec2fzf`, `s3fzf`, `lambdafzf`), GCP (`gcpfzf`, `gcefzf`), Azure (`azfzf`, `vmfzf`).

- Neue Datei: `components/fzf_cloud`
- Feature-Flag: `DOTFILES_ENABLE_CLOUD_FZF`

---

### P016
**Database Connection Manager** · Integration · niedrig

`dbconnect`, `dbadd`, `dbedit` — Picker für PostgreSQL/MySQL/Redis/MongoDB/SQLite mit GPG-verschlüsselten Credentials in `config/databases.json`.

- Neue Datei: `components/db_manager`
- Feature-Flag: `DOTFILES_ENABLE_DB_MANAGER`

---

### P017
**AI Helper Integration** · Integration · niedrig

`ai <question>`, `ai explain <command>`, `ai suggest`, `ai fix` — AI-Unterstützung im Terminal, Support für OpenAI/Anthropic/local LLMs, API-Key-Management in Config.

- Neue Datei: `components/ai_helper`
- Feature-Flag: `DOTFILES_ENABLE_AI_HELPER`

---

### P019
**Theme Switcher** · UX · niedrig

`dot theme list/set/current` — Built-in Themes (minimal, verbose, colorful, monochrome), Custom Themes in `config/themes/`, Per-Host-Konfiguration.

- Neue Datei: `components/theme_switcher`
- Feature-Flag: `DOTFILES_ENABLE_THEMES`

---

### P020
**Command History Insights** · Analytics · niedrig

`dot stats` — Top-20 meistgenutzte Commands, Alias-Vorschläge für häufige Tippfolgen, Erkennung ungenutzter Dotfiles-Features, JSON-Export.

- Neue Datei: `components/history_insights`
- Feature-Flag: `DOTFILES_ENABLE_HISTORY_INSIGHTS`

---

### P022
**FZF Preview Enhancements** · UX · mittel

Syntax-Highlighting via bat, dynamische Preview-Fenstergröße (Toggle per Key), Image-Preview (terminalkabhängig), Preview-Caching, geteilte Helpers in `components/fzf_preview_helpers`.

- Betrifft: alle Komponenten mit fzf
- Flag: `DOTFILES_ENABLE_FZF` (bestehend)

---

### P024
**Network Tools Helpers** · Netzwerk · niedrig

`netfzf` (Ports mit Prozessinfo), `curlfzf` (gespeicherte HTTP-Requests), `sshfzf` (aktive Verbindungen).

- Neue Datei: `components/fzf_network`
- Feature-Flag: `DOTFILES_ENABLE_NETWORK_FZF`

---

### P025
**File Finder mit Kontext** · Navigation · niedrig

`ff [pattern]` — interaktive Dateisuche mit bat-Preview, Actions (open/edit/copy/move/delete), Filter nach Typ/Größe/Datum, ripgrep-Volltextsuche, .gitignore-Support.

- Neue Datei: `components/file_finder`
- Feature-Flag: `DOTFILES_ENABLE_FILE_FINDER`

---

### P026
**Clipboard Manager** · Produktivität · niedrig

`clip` — fzf-Picker für Clipboard-Historie, Auto-Copy für git-Hashes und Pfade, Integration mit clipmenu/copyq.

- Neue Datei: `components/clipboard_manager`
- Feature-Flag: `DOTFILES_ENABLE_CLIPBOARD_MANAGER`

---

### P027
**Password Manager Integration** · Sicherheit · mittel

`pwfzf` — Picker für pass/1Password/Bitwarden, Clipboard-Copy mit Auto-Clear-Timeout, TOTP-Support, Metadaten ohne Secret-Anzeige.

- Neue Datei: `components/password_manager`
- Feature-Flag: `DOTFILES_ENABLE_PASSWORD_MANAGER`

---

### P028
**Weather Widget** · Fun · niedrig

`weather` / `weather forecast` via wttr.in, optionale MOTD-Integration, Standort-Konfiguration (auto-detect oder manuell).

- Neue Datei: `components/weather`
- Feature-Flag: `DOTFILES_ENABLE_WEATHER`

---

### P029
**Calendar Integration** · Produktivität · niedrig

Nächste Events im MOTD, `agenda` Command, Integration mit gcalcli (Google) oder khal (lokal), Event-Filterung und schnelle Event-Erstellung.

- Neue Datei: `components/calendar`
- Feature-Flag: `DOTFILES_ENABLE_CALENDAR`

---

### P030
**Notiz-System** · Produktivität · niedrig

`note [text]` — Schnellnotizen mit Timestamp, `note search` via fzf-Picker, `note edit` in `$EDITOR`, Markdown, Tagging, Storage in `~/.notes/`.

- Neue Datei: `components/notes`
- Feature-Flag: `DOTFILES_ENABLE_NOTES`
