# Dotfiles - Verbesserungsvorschläge

Erstellt: 2026-01-25

## Übersicht

Diese Analyse enthält Vorschläge zur Weiterentwicklung des dotfiles-Repositories, gruppiert nach Priorität und Kategorie.

## TODO-Übersicht

| ID | Titel | Beschreibung | Status | Prio |
|----|-------|--------------|--------|------|
| IMP-001 | ioBroker Source-Validierung | Existenzprüfung vor dem Sourcen von ioBroker-Dateien hinzufügen | offen | hoch |
| IMP-002 | Hardcodierten Username entfernen | `$USER == "darkiop"` Check in ioBroker-Integration entfernen | offen | hoch |
| IMP-003 | WOL MAC-Adressen auslagern | MAC-Adressen aus alias-Datei in verschlüsselte Config verschieben | offen | hoch |
| IMP-004 | Secret-Scanning | Pre-Commit Hooks für API-Keys, Tokens, Credentials (gitleaks/trufflehog) | offen | hoch |
| IMP-005 | IPv6-Erkennung SSH tmux | Regex für IP-Erkennung erweitern um IPv6 zu unterstützen | offen | hoch |
| IMP-006 | Docker Widget Daemon-Status | Unterscheiden zwischen "Daemon down" und "0 Container" | offen | hoch |
| IMP-007 | Startup-Profiler (P006) | `dot profile` Command zur Messung der Shell-Startzeit implementieren | offen | mittel |
| IMP-008 | Lazy-Loading Komponenten | Selten genutzte Commands erst bei Aufruf laden | offen | mittel |
| IMP-009 | Feature-Flag-Caching | Flags einmal vorab berechnen statt 40x aufrufen | offen | mittel |
| IMP-010 | Directory Bookmarks (P003) | `mark`, `jump`, `unmark` Commands implementieren | offen | mittel |
| IMP-011 | Process Manager (P012) | `psfzf` für interaktive Prozessauswahl | offen | mittel |
| IMP-012 | Installer Dry-Run (P018) | `install.sh --dry-run` Modus implementieren | offen | mittel |
| IMP-013 | Architektur-Diagramm | Visuelles Diagramm der Ladereihenfolge in README.md | offen | mittel |
| IMP-014 | Troubleshooting-Guide | Guide für häufige Probleme (Shell-Start, macOS, WSL) | offen | mittel |
| IMP-015 | Kompatibilitätsmatrix | Dokumentation welche Features bash 4+/zsh 5.0+ benötigen | offen | mittel |
| IMP-016 | Error Handling Scripts | `set -euo pipefail` in kritische Scripts einfügen | offen | mittel |
| IMP-017 | PATH-Management | Array-basiertes PATH-Management statt wiederholte Aufrufe | offen | mittel |
| IMP-018 | FZF-Komponente aufteilen | `components/fzf` in `fzf_core` und `fzf_tab_completion` splitten | offen | mittel |
| IMP-019 | Shellcheck Audit | 36 Suppressions in 13 Dateien überprüfen und reduzieren | offen | mittel |
| IMP-020 | Alias-Datei aufteilen | `alias/alias` (372 Zeilen) in logische Teile splitten | offen | niedrig |
| IMP-021 | Plugin-System (P010) | `plugins/` Verzeichnis mit Auto-Discovery für User-Erweiterungen | offen | niedrig |
| IMP-022 | Cheats reorganisieren | 57 Cheat-Dateien in Kategorie-Unterverzeichnisse sortieren | offen | niedrig |
| IMP-023 | CI/CD Pipeline | GitHub Actions mit Shellcheck-Validierung einrichten | offen | niedrig |
| IMP-024 | BATS Test-Suite | Integration Tests mit Bash Automated Testing System | offen | niedrig |
| IMP-025 | dot doctor erweitern | Syntax-Check, Flag-Validierung, Symlink-Health hinzufügen | offen | niedrig |
| IMP-026 | WSL-Version erkennen | `DOTFILES_WSL_VERSION` (1 oder 2) zusätzlich zu boolean | offen | niedrig |
| IMP-027 | macOS bash-Upgrade Guide | Anleitung für bash 4+ Installation auf macOS | offen | niedrig |

**Legende:** Status: `offen` | `in Arbeit` | `erledigt` | `verworfen`

---

## 🔴 Hohe Priorität

### Sicherheit

#### SSH-Integration sourced Dateien ohne Validierung
- **Dateien**: `bashrc:184-185`, `zshrc:173-174`
- **Problem**: ioBroker-Dateien werden ohne Existenzprüfung gesourced
- **Lösung**: Existenzprüfung hinzufügen
  ```bash
  [[ -f ~/.iobroker/iobroker_completions ]] && source ~/.iobroker/iobroker_completions
  [[ -f ~/.iobroker/npm_command_fix ]] && source ~/.iobroker/npm_command_fix
  ```

#### Hardcodierter Benutzername in ioBroker-Check
- **Dateien**: `bashrc:183`, `zshrc:172`
- **Problem**: `$USER == "darkiop"` ist hardcodiert
- **Lösung**: Entfernen oder konfigurierbar machen via Feature-Flag

#### WOL MAC-Adressen in Alias-Datei
- **Datei**: `alias/alias:310-314`
- **Problem**: MAC-Adressen im Klartext in Shell-History
- **Lösung**: In verschlüsselte Config oder Umgebungsvariablen verschieben

#### Secret-Scanning fehlt
- **Problem**: Keine Pre-Commit Hooks für API-Keys, Tokens, Credentials
- **Lösung**: P013 aus IDEAS.md implementieren (gitleaks oder trufflehog)

### Bugs

#### IPv6-Erkennung fehlt in SSH tmux rename
- **Dateien**: `bashrc:170`, `zshrc:161`
- **Problem**: Regex `^[0-9]+(\.[0-9]+){3}$` erkennt nur IPv4
- **Lösung**: Explizite IPv4/IPv6-Erkennung oder vollständigen Hostnamen behalten
  ```bash
  # Aktuelle Implementierung (nur IPv4):
  if [[ $target =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
    : # IPv4 Adresse, behalten
  else
    target=${target%%.*}  # Domain entfernen
  fi

  # Verbessert (IPv4 und IPv6):
  if [[ $target =~ ^[0-9]+(\.[0-9]+){3}$ ]] || [[ $target =~ : ]]; then
    : # IP-Adresse, behalten
  else
    target=${target%%.*}  # Domain entfernen
  fi
  ```

#### Docker Widget unterscheidet nicht zwischen Daemon-Status
- **Datei**: `motd/widgets.sh:61-62`
- **Problem**: Zeigt "0 running" wenn Docker Daemon nicht läuft
- **Lösung**: Daemon-Status separat prüfen und anzeigen

---

## 🟡 Mittlere Priorität

### Performance

#### Startup-Profiler fehlt (P006)
- **Problem**: Keine Möglichkeit, langsame Komponenten zu identifizieren
- **Lösung**: `dot profile` Command implementieren
  ```bash
  dot profile  # Misst Shell-Startzeit pro Komponente
  ```
- **Aufwand**: 2-3 Stunden

#### Lazy-Loading für Komponenten
- **Problem**: Alle Komponenten laden beim Shell-Start
- **Lösung**: Selten genutzte Commands erst bei Aufruf laden
  ```bash
  _load_xyz() {
    [[ -v _xyz_loaded ]] && return
    source ~/dotfiles/components/xyz
    _xyz_loaded=1
  }
  ```

#### Feature-Flag-Checks optimieren
- **Problem**: `dotfiles_flag_enabled` wird 40+ mal beim Start aufgerufen
- **Lösung**: Flags einmal vorab berechnen und cachen

### Features

#### Directory Bookmarks (P003)
- **Beschreibung**: `mark`, `jump`, `unmark` Commands
- **Speicherort**: `~/.dotfiles_bookmarks` (JSON)
- **Aufwand**: 2-3 Stunden

#### Process Manager Helpers (P012)
- **Beschreibung**: `psfzf` für interaktive Prozessauswahl
- **Integration**: Erweitert bestehende FZF-Komponenten
- **Aufwand**: 2-3 Stunden

#### Dry-Run Modus für Installer (P018)
- **Problem**: Keine Vorschau was `install.sh` ändern würde
- **Lösung**: `install.sh --dry-run` implementieren

### Dokumentation

#### Architektur-Diagramm fehlt
- **Problem**: Ladereihenfolge nur durch Code-Lesen verständlich
- **Lösung**: Visuelles Diagramm in README.md
  ```
  bashrc/zshrc
  ├── config/dotfiles.config
  ├── components/platform
  ├── components/feature_flags
  ├── components/*_defaults
  ├── components/*_prompt
  ├── components/fzf*
  ├── alias/*
  └── components/helpers
  ```

#### Troubleshooting-Guide fehlt
- **Themen**:
  - Langsamer Shell-Start diagnostizieren
  - macOS bash 3.2 vs 4+ Probleme
  - WSL-spezifische Gotchas
  - Container-Umgebung Erkennung

#### Kompatibilitätsmatrix fehlt
- **Fragen zu beantworten**:
  - Welche Features brauchen bash 4+?
  - Welche Features brauchen zsh 5.0+?
  - Was funktioniert auf macOS vs Linux?
  - Container-spezifische Einschränkungen?

### Code-Qualität

#### Error Handling in Scripts
- **Problem**: Nur 10 Dateien nutzen `set -e`, nur 5 nutzen `set -o pipefail`
- **Lösung**: `set -euo pipefail` in kritische Scripts einfügen
- **Betroffene Dateien**: `install.sh`, `motd/motd.sh`, `motd/widgets.sh`, alle Widget-Scripts

#### PATH-Management vereinfachen
- **Aktuell** (bashrc/zshrc:14-26):
  ```bash
  ADD_TO_PATH "$HOME/bin"
  ADD_TO_PATH "$HOME/dotfiles/bin"
  ADD_TO_PATH "$HOME/.local/bin"
  ADD_TO_PATH "$HOME/.cargo/bin"
  ```
- **Besser**:
  ```bash
  DOTFILES_PATH_DIRS=(
    "$HOME/bin"
    "$HOME/dotfiles/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  )
  for dir in "${DOTFILES_PATH_DIRS[@]}"; do
    ADD_TO_PATH "$dir"
  done
  ```

#### FZF-Komponente aufteilen
- **Problem**: `components/fzf` ist 166 Zeilen mit komplexer Logik
- **Lösung**: Aufteilen in:
  - `components/fzf_core` (Basis-Setup)
  - `components/fzf_tab_completion` (Feature-gated)

#### Shellcheck Suppressions reduzieren
- **Aktuell**: 36 Suppressions in 13 Dateien
- **Häufige**: SC2312, SC2086, SC1090
- **Lösung**: Audit durchführen, Technical Debt reduzieren

---

## 🟢 Niedrige Priorität

### Organisation

#### Alias-Datei aufteilen
- **Problem**: `alias/alias` hat 372 Zeilen
- **Lösung**: Logische Trennung:
  - `alias/alias-core` (essentiell)
  - `alias/alias-system` (systemctl, reboot, etc.)
  - `alias/alias-dev` (git, docker, etc.)

#### Plugin-System (P010)
- **Problem**: User können nicht einfach erweitern ohne Core-Dateien zu ändern
- **Lösung**: `plugins/` Verzeichnis mit Auto-Discovery

#### Cheats reorganisieren
- **Problem**: 57 Cheat-Dateien flach im Verzeichnis
- **Lösung**: Kategorien als Unterverzeichnisse:
  - `cheats/docker/`
  - `cheats/git/`
  - `cheats/kubernetes/`

### Testing

#### CI/CD Pipeline
- **Problem**: Keine automatisierte Validierung
- **Lösung**: GitHub Actions mit Shellcheck

#### BATS Test-Suite
- **Problem**: Keine Integration Tests
- **Lösung**: BATS (Bash Automated Testing System) einführen
- **Tests für**:
  - Komponenten-Loading in bash und zsh
  - Feature-Flags funktionieren korrekt
  - FZF-Komponenten
  - Git-Alias-Funktionen
  - MOTD-Rendering

#### `dot doctor` erweitern
- **Neue Checks**:
  - Syntax-Validierung aller Shell-Dateien
  - Feature-Flag-Validierung (Typos, unbekannte Flags)
  - Symlink-Integrität
  - Broken Script Source Detection

### Kompatibilität

#### WSL-Version unterscheiden
- **Aktuell**: `DOTFILES_WSL` ist boolean
- **Verbesserung**: `DOTFILES_WSL_VERSION` (1 oder 2) hinzufügen

#### macOS bash-Upgrade Guide
- **Problem**: FZF Tab-Completion braucht bash 4+
- **Lösung**: Upgrade-Anleitung in README.md

---

## ⚡ Quick Wins

| Aufwand | Verbesserung | Datei(en) |
|---------|--------------|-----------|
| 30 min | Hardcodierten Username entfernen | `bashrc`, `zshrc` |
| 30 min | Existenzprüfung für ioBroker-Sources | `bashrc`, `zshrc` |
| 1h | IPv4/IPv6 Erkennung in SSH tmux rename | `bashrc`, `zshrc` |
| 1h | `set -euo pipefail` in install.sh | `install.sh` |
| 1h | Docker Widget: Daemon-Status prüfen | `motd/widgets.sh` |
| 1h | Architektur-Diagramm erstellen | `README.md` |

---

## Zusammenfassung nach Kategorie

| Kategorie | Hoch | Mittel | Niedrig |
|-----------|------|--------|---------|
| Sicherheit | 4 | - | - |
| Bugs | 2 | - | - |
| Performance | - | 3 | - |
| Features | - | 3 | 1 |
| Dokumentation | - | 3 | - |
| Code-Qualität | - | 4 | - |
| Organisation | - | - | 3 |
| Testing | - | - | 3 |
| Kompatibilität | - | - | 2 |

---

## Referenzen

- Siehe auch: `IDEAS.md` für weitere Feature-Vorschläge
- Siehe auch: `CLAUDE.md` für Codebase-Konventionen
