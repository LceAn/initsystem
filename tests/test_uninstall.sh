#!/usr/bin/env bash
set -euo pipefail

test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT

export HOME="$test_root/home"
export INITSYSTEM_STATE_DIR="$test_root/state"
export INITSYSTEM_LOG_DIR="$test_root/log"
mkdir -p "$HOME" "$INITSYSTEM_STATE_DIR"

# shellcheck source=init_system.sh
source "$(dirname "$0")/../init_system.sh"

printf '%s\n' 'original config' > "$HOME/.zshrc"
recordZshrcState
test "$(cat "$INITSYSTEM_STATE_DIR/zshrc.before-initsystem")" = "original config"

printf '%s\n' 'managed config' > "$HOME/.zshrc"
recordZshrcState
test "$(cat "$INITSYSTEM_STATE_DIR/zshrc.before-initsystem")" = "original config"

mkdir -p "$HOME/.oh-my-zsh"
: > "$INITSYSTEM_STATE_DIR/oh-my-zsh-installed"

uninstallOhMyZsh > /dev/null

test ! -e "$HOME/.oh-my-zsh"
test "$(cat "$HOME/.zshrc")" = "original config"

rm -f -- "$HOME/.zshrc"
recordZshrcState
printf '%s\n' 'script-created config' > "$HOME/.zshrc"
mkdir -p "$HOME/.oh-my-zsh"
: > "$INITSYSTEM_STATE_DIR/oh-my-zsh-installed"

uninstallOhMyZsh > /dev/null

test ! -e "$HOME/.oh-my-zsh"
test ! -e "$HOME/.zshrc"

mkdir -p "$HOME/.oh-my-zsh"
printf '%s\n' 'user config' > "$HOME/.zshrc"
uninstallOhMyZsh > /dev/null

test -d "$HOME/.oh-my-zsh"
test "$(cat "$HOME/.zshrc")" = "user config"

printf '%s\n' '卸载边界测试通过'
