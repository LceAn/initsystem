# Changelog

All notable changes to initsystem are documented here. Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased] - 2026-08-30

### Added
- Added `CHANGELOG.md` and `ROADMAP.md`; README now links to project documentation.

### Notes
- Documentation-only round; `init_system.sh` behavior unchanged.

## Summary of recent history

- 2026-08-04 `ci: satisfy distro detection shellcheck` — shellcheck cleanups in distro detection.
- 2026-08-04 `safety: preserve user shell configuration` — safer uninstall boundary (state records under `${XDG_STATE_HOME:-$HOME/.local/state}/initsystem`).
- 1.1 — state-record based safe uninstall; `.zshrc` backup before installation.

## [1.1] - 2026-07

- Safe uninstall boundary introduced (see README "Safe uninstall boundary").
